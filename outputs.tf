output "resource_group_name" {
  description = "Name of the cloned resource group."
  value       = azurerm_resource_group.this.name
}

output "nat_gateway_public_ip" {
  description = "New outbound public IP allocated to the worker NAT gateway."
  value       = azurerm_public_ip.nat_worker.ip_address
}

output "standalone_bastion_public_ip" {
  description = "New public IP allocated to the standalone bastion VM."
  value       = azurerm_public_ip.standalone_bastion.ip_address
}

output "standalone_bastion_private_ip" {
  description = "Private IP assigned to the standalone bastion VM."
  value       = azurerm_network_interface.standalone_bastion.private_ip_address
}

output "worker_private_ip" {
  description = "Private IP assigned to WorkerNode."
  value       = azurerm_network_interface.worker.private_ip_address
}

output "target_private_ip" {
  description = "Private IP assigned to TargetVM."
  value       = azurerm_network_interface.target.private_ip_address
}

output "standalone_bastion_private_key_path" {
  description = "Local path to the generated standalone bastion SSH private key."
  value       = local_sensitive_file.standalone_bastion_private_key.filename
}

output "worker_password_path" {
  description = "Local path to WorkerNode's generated password."
  value       = local_sensitive_file.worker_password.filename
}

output "target_password_path" {
  description = "Local path to TargetVM's generated password."
  value       = local_sensitive_file.target_password.filename
}

output "standalone_bastion_ssh_command" {
  description = "SSH command for the standalone bastion VM."
  value       = "ssh -i ${local_sensitive_file.standalone_bastion_private_key.filename} ${var.admin_username}@${azurerm_public_ip.standalone_bastion.ip_address}"
}
