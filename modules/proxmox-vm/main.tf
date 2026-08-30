resource "proxmox_virtual_environment_download_file" "ubuntu_cloud_image" {
  content_type = "import"
  datastore_id = var.image_datastore_id
  node_name    = var.proxmox_node_name
  url          = var.ubuntu_image_url

  file_name = var.ubuntu_image_file_name
}

resource "proxmox_virtual_environment_file" "cloud_init_user_data" {
  for_each = var.vms

  content_type = "snippets"
  datastore_id = var.snippet_datastore_id
  node_name    = var.proxmox_node_name

  source_raw {
    data = templatefile("${path.module}/cloud-init/user-data.yaml.tftpl", {
      hostname        = each.value.name
      ssh_username    = var.ssh_username
      ssh_public_keys = var.ssh_public_keys
      timezone        = var.timezone
    })

    file_name = "${each.value.name}-user-data.yaml"
  }
}

resource "proxmox_virtual_environment_vm" "vm" {
  for_each = var.vms

  name        = each.value.name
  description = "Kubernetes Platform ${var.environment} ${each.value.role} node"
  node_name   = var.proxmox_node_name
  vm_id       = each.value.vm_id

  started         = true
  on_boot         = true
  stop_on_destroy = true
  tags            = var.tags

  agent {
    enabled = true
  }

  cpu {
    cores = each.value.cpu_cores
  }

  memory {
    dedicated = each.value.memory_mb
  }

  disk {
    datastore_id = var.vm_datastore_id
    import_from  = proxmox_virtual_environment_download_file.ubuntu_cloud_image.id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = each.value.disk_gb
  }

  initialization {
    datastore_id = var.cloud_init_datastore_id

    ip_config {
      ipv4 {
        address = "${each.value.ip_address}/${each.value.cidr_prefix}"
        gateway = each.value.gateway
      }
    }

    user_data_file_id = proxmox_virtual_environment_file.cloud_init_user_data[each.key].id
  }

  network_device {
    bridge = var.network_bridge
    model  = "virtio"
  }
}
