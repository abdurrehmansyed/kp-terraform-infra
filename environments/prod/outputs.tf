output "environment" {
  description = "Environment name."
  value       = "prod"
}

output "vm_names" {
  description = "VM names created for the prod environment."
  value       = module.kubernetes_nodes.vm_names
}

output "vm_ids" {
  description = "VM IDs created for the prod environment."
  value       = module.kubernetes_nodes.vm_ids
}

output "vm_ipv4_addresses" {
  description = "Static IPv4 addresses assigned to prod VMs."
  value       = module.kubernetes_nodes.vm_ipv4_addresses
}

output "vm_roles" {
  description = "Role assigned to each prod VM."
  value       = module.kubernetes_nodes.vm_roles
}
