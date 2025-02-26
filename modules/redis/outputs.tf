output "redis_id" {
  value       = azurerm_redis_cache.main.id
  description = "ID of the Redis instance"
}

output "redis_hostname" {
  value       = azurerm_redis_cache.main.hostname
  description = "Hostname of the Redis instance"
}

output "redis_port" {
  value       = 6380
  description = "Port of the Redis instance (SSL port)"
}

output "redis_primary_key" {
  value       = azurerm_redis_cache.main.primary_access_key
  description = "Primary access key for the Redis instance"
  sensitive   = true
}
