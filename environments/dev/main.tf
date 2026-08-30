locals {
  environment = "dev"

  vms = {
    dev-cp-01 = {
      vm_id       = 101
      name        = "dev-cp-01"
      role        = "control-plane"
      ip_address  = "192.168.10.11"
      cidr_prefix = 24
      gateway     = "192.168.10.1"
      cpu_cores   = 2
      memory_mb   = 4096
      disk_gb     = 40
    }

    dev-worker-01 = {
      vm_id       = 111
      name        = "dev-worker-01"
      role        = "worker"
      ip_address  = "192.168.10.21"
      cidr_prefix = 24
      gateway     = "192.168.10.1"
      cpu_cores   = 2
      memory_mb   = 4096
      disk_gb     = 40
    }

    dev-worker-02 = {
      vm_id       = 112
      name        = "dev-worker-02"
      role        = "worker"
      ip_address  = "192.168.10.22"
      cidr_prefix = 24
      gateway     = "192.168.10.1"
      cpu_cores   = 2
      memory_mb   = 4096
      disk_gb     = 40
    }
  }
}

module "kubernetes_nodes" {
  source = "../../modules/proxmox-vm"

  environment             = local.environment
  proxmox_node_name       = var.proxmox_node_name
  image_datastore_id      = var.image_datastore_id
  vm_datastore_id         = var.vm_datastore_id
  snippet_datastore_id    = var.snippet_datastore_id
  cloud_init_datastore_id = var.cloud_init_datastore_id
  network_bridge          = var.network_bridge
  ubuntu_image_url        = var.ubuntu_image_url
  ubuntu_image_file_name  = var.ubuntu_image_file_name
  ssh_username            = var.ssh_username
  ssh_public_keys         = var.ssh_public_keys
  timezone                = var.timezone

  tags = [
    "dev",
    "kubernetes-platform",
    "terraform"
  ]

  vms = local.vms
}
