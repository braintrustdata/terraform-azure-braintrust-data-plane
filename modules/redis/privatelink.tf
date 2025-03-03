resource "azurerm_private_endpoint" "redis" {
  name                          = "${var.deployment_name}-redis"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  subnet_id                     = var.private_endpoint_subnet_id
  custom_network_interface_name = "${var.deployment_name}-redis"

  private_dns_zone_group {
    name                 = "redis"
    private_dns_zone_ids = [azurerm_private_dns_zone.redis.id]
  }

  private_service_connection {
    name                           = "${var.deployment_name}-redis"
    private_connection_resource_id = azurerm_redis_cache.redis.id
    is_manual_connection           = false
    subresource_names              = ["redisCache"]
  }
}

resource "azurerm_private_dns_zone" "redis" {
  # https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-dns
  name                = "redis.cache.windows.net"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "redis" {
  name                  = "redis"
  private_dns_zone_name = azurerm_private_dns_zone.redis.name
  virtual_network_id    = var.virtual_network_id
  resource_group_name   = var.resource_group_name
}
