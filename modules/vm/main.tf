resource "libvirt_volume" "vm_disk" {
  name   = "${var.vm_name}.qcow2"
  pool   = var.storage_pool
  source = var.disk_image
  format = "qcow2"
}


resource "libvirt_cloudinit_disk" "cloudinit" {
  name      = "${var.vm_name}-cloudinit.iso"
  user_data = data.template_file.user_data.rendered
  pool      = var.storage_pool
}

resource "libvirt_domain" "vm" {
  name   = var.vm_name
  memory = var.memory_mb
  vcpu   = var.vcpu

  disk {
    volume_id = libvirt_volume.vm_disk.id
  }

  network_interface {
    network_name = "default"
  }

  graphics {
    type        = "vnc"
    listen_type = "address"
    autoport    = true
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  boot_device {
    dev = ["hd"]
  }
cloudinit = libvirt_cloudinit_disk.cloudinit.id
}


resource "random_password" "fedora_pw" {
  length  = 12
  special = false
}

resource "null_resource" "password_hash" {
  provisioner "local-exec" {
    command = "openssl passwd -6 ${var.user_password} > .password_hash"
  }
}

data "local_file" "password_hash" {
  depends_on = [null_resource.password_hash]
  filename   = ".password_hash"
}

data "template_file" "user_data" {
  template = file("${path.module}/cloud-init.yaml")
  vars = {
    hostname      = var.vm_name
    ssh_pub_key   = var.ssh_pub_key
    password_hash = data.local_file.password_hash.content
  }
}
