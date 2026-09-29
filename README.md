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
```sh
make proxmox
```