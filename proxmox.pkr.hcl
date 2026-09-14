packer {
  required_plugins {
    proxmox = {
      version = "1.2.3"
      source  = "github.com/hashicorp/proxmox"
    }
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = "1.1.4"
    }
  }
}

source "proxmox-iso" "pve" {
    proxmox_url               = var.pve_url
    insecure_skip_tls_verify  = true
    username                  = var.pve_username
    token                     = var.pve_token
    node                      = var.pve_node_name
    task_timeout              = "15m"

    vm_name                   = local.build_name
    template_name             = "${local.build_name}-tmp"
    os                        = "l26"
    cpu_type                  = "host"
    cores                     = 2
    sockets                   = 1
    memory                    = 6144
    scsi_controller           = "virtio-scsi-single"
    serials                   = ["socket"]
    communicator              = "ssh"
    qemu_agent                = true
    bios                      = "seabios"

    disks {
        storage_pool            = var.storage_pool_disks
        disk_size               = "100G"
        format                  = "qcow2"
        io_thread               = true
        type                    = "scsi"
    }

    network_adapters {
        model                   = "virtio"
        bridge                  = var.nic_bridge
        vlan_tag                = var.nic_vlan
    }

    boot_iso {
        type                    = "scsi"
        iso_download_pve        = true
        iso_storage_pool        = var.storage_pool_iso
        iso_url                 = "${local.iso_url}/${local.iso_file}"
        iso_checksum            = "sha256:${local.iso_checksum}"
        unmount                 = true
    }

    additional_iso_files { 
        type                    = "scsi"
        cd_content              = local.unattended
        cd_label                = local.cd_files
        iso_storage_pool        = var.storage_pool_iso
        unmount                 = true
    }

    ssh_host                  = var.ip
    ssh_username              = "root"
    ssh_private_key_file      = var.ssh_private_key_file
    ssh_timeout               = "30m"

    boot_wait                 = "20s"
    boot_command = [
        "<down><down><down><enter><wait5s>",
        "<down><down><down><down><down><enter>",
        "<wait45s>",
        "proxmox-fetch-answer partition ${local.cd_files} > /run/automatic-installer-answers<enter><wait>exit<enter>",
        "<wait3m>"
    ]
}

build {
    sources = ["sources.proxmox-iso.pve"]

    provisioner "shell" {
        inline = [ 
            "apt update && apt upgrade -y",
            "apt install -y qemu-guest-agent"
        ]
    }

    provisioner "ansible" {
        playbook_file       = "provisioning/playbook.yaml"
        galaxy_file         = "provisioning/requirements.yaml"
        extra_arguments     = [ "-vv" ]
        user                = "root"
        ansible_env_vars    = ["ANSIBLE_CONFIG=provisioning/ansible.cfg"]
    }
}