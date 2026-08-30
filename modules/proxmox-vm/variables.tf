variable "environment" {
  description = "Environment name. Example: dev, staging, prod."
  type        = string
}

variable "proxmox_node_name" {
  description = "Name of the Proxmox node where VMs will be created. Example: pve."
  type        = string
}

variable "image_datastore_id" {
  description = "Proxmox datastore used to store the downloaded Ubuntu cloud image. Example: local."
  type        = string
}

variable "vm_datastore_id" {
  description = "Proxmox datastore used for VM disks. Example: local-lvm."
  type        = string
}

variable "snippet_datastore_id" {
  description = "Proxmox datastore used for cloud-init snippets. This datastore must have Snippets enabled. Example: local."
  type        = string
}

variable "cloud_init_datastore_id" {
  description = "Proxmox datastore used for the VM cloud-init drive. Example: local-lvm."
  type        = string
}

variable "network_bridge" {
  description = "Proxmox Linux bridge used by the VM network interface. Example: vmbr0."
  type        = string
}

variable "ubuntu_image_url" {
  description = "URL for the Ubuntu cloud image."
  type        = string
}

variable "ubuntu_image_file_name" {
  description = "File name used when saving the Ubuntu cloud image in Proxmox."
  type        = string
}

variable "ssh_username" {
  description = "Linux user created inside each VM by cloud-init."
  type        = string
}

variable "ssh_public_keys" {
  description = "SSH public keys allowed to access the VM user."
  type        = list(string)
}

variable "timezone" {
  description = "Timezone configured inside each VM."
  type        = string
}

variable "tags" {
  description = "Tags applied to Proxmox VMs."
  type        = list(string)
  default     = []
}

variable "vms" {
  description = "Map of VMs to create."
  type = map(object({
    vm_id       = number
    name        = string
    role        = string
    ip_address  = string
    cidr_prefix = number
    gateway     = string
    cpu_cores   = number
    memory_mb   = number
    disk_gb     = number
  }))
}
