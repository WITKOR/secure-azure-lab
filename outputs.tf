output "resource_group_name" {
  description = "Name of the Azure resource group"
  value       = azurerm_resource_group.rg.name
}

output "virtual_network_name" {
  description = "Name of the Azure virtual network"
  value       = module.network.vnet_name
}

output "subnet_name" {
  description = "Name of the Azure subnet"
  value       = module.network.subnet_name
}

output "network_security_group_name" {
  description = "Name of the Azure network security group"
  value       = module.network.nsg_name
}

output "storage_account_name" {
  description = "Name of the Azure storage account"
  value       = azurerm_storage_account.storage.name
}