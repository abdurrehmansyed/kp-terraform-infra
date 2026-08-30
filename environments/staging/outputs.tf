output "environment" {
  description = "Environment name."
  value       = "staging"
}

output "vm_names" {
  description = "VM names created for the staging environment."
  value       = module.kubernetes_nodes.vm_names
}

output "vm_ids" {
  description = "VM IDs created for the staging environment."
  value       = module.kubernetes_nodes.vm_ids
}

output "vm_ipv4_addresses" {
  description = "Static IPv4 addresses assigned to staging VMs."
  value       = module.kubernetes_nodes.vm_ipv4_addresses
}

output "vm_roles" {
  description = "Role assigned to each staging VM."
  value       = module.kubernetes_nodes.vm_roles
}
