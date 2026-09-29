### packer-proxmox-pve-builds

Creating a Proxmox VE template for development and debugging. The [proxmox-iso](https://developer.hashicorp.com/packer/integrations/hashicorp/proxmox/latest/components/builder/iso) builder is used for building an image

Template parameters:
```sh
OS version: Proxmox 9.2.1
CPU type: host
Cores: 2
Socket: 1
RAM: 6Gb
Disk: 100 Gb
Disk type: qcow2
QEMU-agent: enabled
```

### Usage

1. Create a .env file in the root of the project with the following content:
```sh
PKR_VAR_pve_url=https://192.168.0.2:8006/api2/json
PKR_VAR_pve_username=user@pam!packer
PKR_VAR_pve_token=11111111-bbbbb-ccccccc-4444-dddddddddd
PKR_VAR_pve_node_name=pve

PKR_VAR_nic_bridge=vmbr0

PKR_VAR_storage_pool_disks=local

PKR_VAR_ssh_password='$6$aJcAVcNj.....'                             # Use: mkpasswd -m sha-512

PKR_VAR_ssh_pub_key='"ssh-rsa AAAABBBBBCCCCCCCCC1111111111 pve"'
PKR_VAR_ssh_private_key_file=/home/user/.ssh/key

PKR_VAR_ip=192.168.1.3
PKR_VAR_mask=24
PKR_VAR_gateway=192.168.1.1
```
2. Run build:
```sh
make proxmox
```