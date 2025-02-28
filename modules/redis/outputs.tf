output "redis_id" {
  description = "The ID of the Redis Cache"
  value       = azurerm_redis_cache.redis.id
}

output "redis_hostname" {
  description = "The hostname of the Redis Cache"
  value       = azurerm_redis_cache.redis.hostname
}

output "redis_ssl_port" {
  description = "The SSL port of the Redis Cache"
  value       = azurerm_redis_cache.redis.ssl_port
}

output "redis_password" {
  description = "The primary access key for the Redis Cache"
  value       = azurerm_redis_cache.redis.primary_access_key
  sensitive   = true
}

output "redis_connection_string" {
  description = "The connection string for the Redis Cache"
  value       = "rediss://:${azurerm_redis_cache.redis.primary_access_key}@${azurerm_redis_cache.redis.hostname}:${azurerm_redis_cache.redis.ssl_port}"
  sensitive   = true
}
