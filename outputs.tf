output "resource_group_name" {
  value       = azurerm_resource_group.main.name
  description = "Name of the resource group containing Braintrust resources"
}

output "main_vnet_id" {
  value       = module.main_vnet.vnet_id
  description = "ID of the main VNet that contains the Braintrust resources"
}

output "main_vnet_address_space" {
  value       = module.main_vnet.vnet_address_space
  description = "Address space of the main VNet"
}

output "postgres_database_id" {
  value       = module.database.postgres_database_id
  description = "ID of the main Braintrust Postgres database"
}

output "redis_id" {
  value       = module.redis.redis_id
  description = "ID of the Redis instance"
}
