output "vnet_id" {
  value       = azurerm_virtual_network.main.id
  description = "ID of the virtual network"
}

output "vnet_name" {
  value       = azurerm_virtual_network.main.name
  description = "Name of the virtual network"
}

output "vnet_address_space" {
  value       = tolist(azurerm_virtual_network.main.address_space)[0]
  description = "Address space of the virtual network"
}

output "services_subnet_id" {
  value       = azurerm_subnet.services.id
  description = "ID of the services subnet"
}

output "services_network_security_group_id" {
  value       = azurerm_network_security_group.services.id
  description = "ID of the services network security group"
}

output "private_endpoint_subnet_id" {
  value       = azurerm_subnet.private_endpoint.id
  description = "ID of the private endpoint subnet"
}

output "private_endpoint_network_security_group_id" {
  value       = azurerm_network_security_group.private_endpoint.id
  description = "ID of the private endpoint subnet's network security group"
}
