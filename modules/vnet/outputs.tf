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

output "database_subnet_id" {
  value       = azurerm_subnet.database.id
  description = "ID of the database subnet"
}

output "database_network_security_group_id" {
  value       = azurerm_network_security_group.database.id
  description = "ID of the database network security group"
}

output "redis_subnet_id" {
  value       = azurerm_subnet.redis.id
  description = "ID of the redis subnet"
}

output "redis_network_security_group_id" {
  value       = azurerm_network_security_group.redis.id
  description = "ID of the redis network security group"
}

output "gateway_subnet_id" {
  value       = azurerm_subnet.gateway-lb.id
  description = "ID of the gateway subnet"
}

output "gateway_network_security_group_id" {
  value       = azurerm_network_security_group.gateway-lb.id
  description = "ID of the gateway network security group"
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
  description = "ID of the private endpoint network security group"
}
