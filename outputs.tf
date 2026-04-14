output "resource_group_name" {
  description = "Name of the Azure resource group"
  value       = azurerm_resource_group.rg.name
}

output "virtual_network_name" {
  description = "Name of the Azure virtual network"
  value       = azurerm_virtual_network.vnet.name
}

output "subnet_name" {
  description = "Name of the Azure subnet"
  value       = azurerm_subnet.subnet.name
}

output "network_security_group_name" {
  description = "Name of the Azure network security group"
  value       = azurerm_network_security_group.nsg.name
}

output "storage_account_name" {
  description = "Name of the Azure storage account"
  value       = azurerm_storage_account.storage.name
}