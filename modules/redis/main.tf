resource "azurerm_redis_cache" "redis" {
  name                = "${var.deployment_name}-redis"
  location            = var.location
  resource_group_name = var.resource_group_name

  capacity            = var.redis_capacity
  family              = var.redis_family
  sku_name            = var.redis_sku_name
  minimum_tls_version = "1.2"
  redis_version       = var.redis_version
}


resource "azurerm_key_vault_secret" "redis_password" {
  name         = "redis-password"
  value        = azurerm_redis_cache.redis.primary_access_key
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "redis_connection_string" {
  name         = "redis-connection-string"
  value        = "rediss://:${azurerm_redis_cache.redis.primary_access_key}@${azurerm_redis_cache.redis.hostname}:${azurerm_redis_cache.redis.ssl_port}"
  key_vault_id = var.key_vault_id
}
