output "vnet_id" {
  value       = azurerm_virtual_network.main.id
  description = "ID of the virtual network"
}

output "vnet_name" {
  value       = azurerm_virtual_network.main.name
  description = "Name of the virtual network"
}

output "vnet_address_space" {
  value       = azurerm_virtual_network.main.address_space[0]
  description = "Address space of the virtual network"
}

output "public_subnet_id" {
  value       = azurerm_subnet.public.id
  description = "ID of the public subnet"
}

output "private_subnet_1_id" {
  value       = azurerm_subnet.private_1.id
  description = "ID of the first private subnet"
}

output "private_subnet_2_id" {
  value       = azurerm_subnet.private_2.id
  description = "ID of the second private subnet"
}

output "private_subnet_3_id" {
  value       = azurerm_subnet.private_3.id
  description = "ID of the third private subnet"
}

output "default_nsg_id" {
  value       = azurerm_network_security_group.default.id
  description = "ID of the default network security group"
}

output "public_route_table_id" {
  value       = azurerm_route_table.public.id
  description = "ID of the public route table"
}

output "private_route_table_id" {
  value       = azurerm_route_table.private.id
  description = "ID of the private route table"
}
