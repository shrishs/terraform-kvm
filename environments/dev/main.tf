module "rhel_vm" {
  source      = "../../modules/vm"
  vm_name     = var.vm_name
  memory_mb   = var.memory_mb
  vcpu        = var.vcpu
  disk_image  = var.disk_image
  storage_pool = var.storage_pool
  ssh_pub_key   = var.ssh_pub_key
  user_password = var.user_password 

  providers = {
    libvirt = libvirt
  }
 }

