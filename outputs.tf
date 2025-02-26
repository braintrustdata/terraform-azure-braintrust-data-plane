output "resource_group_name" {
  value       = azurerm_resource_group.main.name
  description = "Name of the resource group containing Braintrust resources"
}

output "main_vnet_id" {
  value       = module.main_vnet.vnet_id
  description = "ID of the main VNet that contains the Braintrust resources"
}

output "quarantine_vnet_id" {
  value       = var.enable_quarantine_vnet ? module.quarantine_vnet[0].vnet_id : null
  description = "ID of the quarantine VNet that user functions run inside of."
}

output "main_vnet_address_space" {
  value       = module.main_vnet.vnet_address_space
  description = "Address space of the main VNet"
}

output "main_vnet_default_nsg_id" {
  value       = module.main_vnet.default_nsg_id
  description = "ID of the default network security group in the main VNet"
}

output "main_vnet_public_subnet_id" {
  value       = module.main_vnet.public_subnet_id
  description = "ID of the public subnet in the main VNet"
}

output "main_vnet_private_subnet_1_id" {
  value       = module.main_vnet.private_subnet_1_id
  description = "ID of the first private subnet in the main VNet"
}

output "main_vnet_private_subnet_2_id" {
  value       = module.main_vnet.private_subnet_2_id
  description = "ID of the second private subnet in the main VNet"
}

output "main_vnet_private_subnet_3_id" {
  value       = module.main_vnet.private_subnet_3_id
  description = "ID of the third private subnet in the main VNet"
}

output "main_vnet_public_route_table_id" {
  value       = module.main_vnet.public_route_table_id
  description = "ID of the public route table in the main VNet"
}

output "main_vnet_private_route_table_id" {
  value       = module.main_vnet.private_route_table_id
  description = "ID of the private route table in the main VNet"
}

output "postgres_database_id" {
  value       = module.database.postgres_database_id
  description = "ID of the main Braintrust Postgres database"
}

output "redis_id" {
  value       = module.redis.redis_id
  description = "ID of the Redis instance"
}

output "api_url" {
  value       = module.services.api_url
  description = "The primary endpoint for the dataplane API. This is the value that should be entered into the braintrust dashboard under API URL."
}
