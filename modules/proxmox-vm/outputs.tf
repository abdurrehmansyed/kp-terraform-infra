output "vm_names" {
  description = "Names of VMs created by this module."
  value       = [for vm in proxmox_virtual_environment_vm.vm : vm.name]
}

output "vm_ids" {
  description = "VM IDs created by this module."
  value       = { for key, vm in proxmox_virtual_environment_vm.vm : key => vm.vm_id }
}

output "vm_ipv4_addresses" {
  description = "Static IPv4 addresses assigned to VMs."
  value       = { for key, vm in var.vms : key => vm.ip_address }
}

output "vm_roles" {
  description = "Role assigned to each VM."
  value       = { for key, vm in var.vms : key => vm.role }
}
