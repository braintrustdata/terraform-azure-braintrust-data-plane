output "redis_id" {
  value       = azurerm_redis_cache.redis.id
  description = "ID of the Redis instance"
}

output "redis_hostname" {
  value       = azurerm_redis_cache.redis.hostname
  description = "Hostname of the Redis instance"
}

output "redis_port" {
  value       = 6380
  description = "Port of the Redis instance (TLS port)"
}

output "redis_primary_key" {
  value       = azurerm_redis_cache.redis.primary_access_key
  description = "Primary access key for the Redis instance"
  sensitive   = true
}

output "redis_url" {
  value       = "rediss://:${azurerm_redis_cache.redis.primary_access_key}@${azurerm_redis_cache.redis.hostname}:${azurerm_redis_cache.redis.ssl_port}"
  description = "URL of the Redis instance"
}
