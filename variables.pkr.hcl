locals {
    build_name = "proxmox-9"

    iso_url = "https://enterprise.proxmox.com/iso"
    iso_file = "proxmox-ve_9.2-1.iso"
    iso_checksum = "4e88fe416df9b527624a175f24c9aa07c714d3332afb1ee3dbf3879573ef2c6c"

    answer_filename = "answer.toml"
    cd_files = "cidata"
    unattended = {
      "/${local.answer_filename}" = templatefile(abspath("${path.root}/${local.cd_files}/answer.toml.pkrtpl.hcl"), { var = var })
    }
}

variable "pve_url" {
    type = string
}

variable "pve_username" {
    type = string
}

variable "pve_token" {
    type = string
}

variable "pve_node_name" {
    type = string
}

variable "storage_pool_disks" {
    type = string
}

variable "storage_pool_iso" {
    type = string
    default = "local"
}

variable "nic_bridge" {
  type = string
  default = "vmbr0" 
}

variable "nic_vlan" {
  type = string
  default = null
}

variable "ssh_password" {
    type = string
}

variable "ssh_pub_key" {
    type = string
}

variable "ssh_private_key_file" {
    type = string
}

variable "ip" {
    type = string
}

variable "mask" {
    type = string
}

variable "gateway" {
    type = string
}