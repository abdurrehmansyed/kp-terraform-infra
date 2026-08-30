output "environment" {
  description = "Environment name."
  value       = "dev"
}

output "vm_names" {
  description = "VM names created for the dev environment."
  value       = module.kubernetes_nodes.vm_names
}

output "vm_ids" {
  description = "VM IDs created for the dev environment."
  value       = module.kubernetes_nodes.vm_ids
}

output "vm_ipv4_addresses" {
  description = "Static IPv4 addresses assigned to dev VMs."
  value       = module.kubernetes_nodes.vm_ipv4_addresses
}

output "vm_roles" {
  description = "Role assigned to each dev VM."
  value       = module.kubernetes_nodes.vm_roles
}
