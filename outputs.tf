output "resource_group_name" {
  value       = azurerm_resource_group.main.name
  description = "Name of the resource group containing Braintrust resources"
}

output "main_vnet_id" {
  value       = var.existing_vnet.id == "" ? module.main_vnet[0].vnet_id : var.existing_vnet.id
  description = "ID of the main VNet that contains the Braintrust resources"
}

output "postgres_database_id" {
  value       = module.database.postgres_database_id
  description = "ID of the main Braintrust Postgres database"
}

output "redis_id" {
  value       = module.redis.redis_id
  description = "ID of the Redis instance"
}

// TDOO expose stoarage account connection string
