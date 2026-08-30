variable "proxmox_endpoint" {
  description = "Proxmox API endpoint. Example: https://192.168.1.10:8006/"
  type        = string
}

variable "proxmox_api_token" {
  description = "Proxmox API token in the format user@realm!tokenid=secret."
  type        = string
  sensitive   = true
}

variable "proxmox_insecure" {
  description = "Set to true when Proxmox uses a self-signed certificate."
  type        = bool
  default     = true
}

variable "proxmox_ssh_username" {
  description = "SSH username Terraform uses to connect to the Proxmox node when needed. Example: root."
  type        = string
  default     = "root"
}

variable "proxmox_node_name" {
  description = "Name of the Proxmox node where VMs will be created. Example: pve."
  type        = string
}

variable "image_datastore_id" {
  description = "Datastore for downloaded Ubuntu cloud image. Example: local."
  type        = string
}

variable "vm_datastore_id" {
  description = "Datastore for VM disks. Example: local-lvm."
  type        = string
}

variable "snippet_datastore_id" {
  description = "Datastore for cloud-init snippet files. Must have Snippets enabled. Example: local."
  type        = string
}

variable "cloud_init_datastore_id" {
  description = "Datastore for VM cloud-init drive. Example: local-lvm."
  type        = string
}

variable "network_bridge" {
  description = "Proxmox bridge used for VM networking. Example: vmbr0."
  type        = string
}

variable "ssh_username" {
  description = "Linux username created inside each Ubuntu VM."
  type        = string
  default     = "ubuntu"
}

variable "ssh_public_keys" {
  description = "SSH public keys allowed to log into the Ubuntu VM user."
  type        = list(string)
}

variable "timezone" {
  description = "Timezone configured inside the VMs."
  type        = string
  default     = "America/Los_Angeles"
}

variable "ubuntu_image_url" {
  description = "Ubuntu 24.04 LTS cloud image URL."
  type        = string
  default     = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
}

variable "ubuntu_image_file_name" {
  description = "Ubuntu 24.04 LTS cloud image file name in Proxmox."
  type        = string
  default     = "dev-noble-server-cloudimg-amd64.qcow2"
}
