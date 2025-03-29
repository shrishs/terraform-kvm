variable "vm_name" {}
variable "memory_mb" {}
variable "vcpu" {}
variable "disk_image" {}
variable "storage_pool" {}

variable "ssh_pub_key" {
  type = string
}

variable "user_password" {
  type = string
}

