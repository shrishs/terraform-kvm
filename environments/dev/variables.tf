variable "vm_name" {}
variable "memory_mb" {}
variable "vcpu" {}
variable "disk_image" {}
variable "storage_pool" {}

variable "ssh_pub_key" {
  description = "Public SSH key for VM access"
  type        = string
}

variable "user_password" {
  description = "Password for the fedora user"
  type        = string
}

