resource "azurerm_redis_cache" "main" {
  name                = "redis-${var.deployment_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  capacity            = var.redis_capacity
  family              = var.redis_family
  sku_name            = var.redis_sku_name
  minimum_tls_version = "1.2"
  redis_version       = var.redis_version

  redis_configuration {
    maxmemory_policy = "volatile-lru"
  }

  tags = {
    deployment = var.deployment_name
  }
}
