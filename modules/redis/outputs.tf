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

output "redis_password_secret_id" {
  description = "The ID of the Key Vault secret for the Redis Cache password"
  value       = azurerm_key_vault_secret.redis_password.id
}

output "redis_password_secret_name" {
  description = "The name of the Key Vault secret for the Redis Cache password"
  value       = azurerm_key_vault_secret.redis_password.name
}

output "redis_application_security_group_name" {
  value       = azurerm_application_security_group.main_redis_endpoint.name
  description = "Name of the redis application security group"
}
