resource "azurerm_private_dns_zone" "main" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "main" {
  name                  = local.db_name
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.main.name
  virtual_network_id    = var.vnet_id
}

resource "azurerm_private_endpoint" "main" {
  name                = local.db_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_dns_zone_group {
    name                 = local.db_name
    private_dns_zone_ids = [azurerm_private_dns_zone.main.id]
  }

  private_service_connection {
    name                           = local.db_name
    private_connection_resource_id = azurerm_postgresql_flexible_server.main.id
    subresource_names              = ["postgresqlServer"]
    is_manual_connection           = false
  }
}

resource "azurerm_application_security_group" "main_db_endpoint" {
  name                = local.db_name
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_endpoint_application_security_group_association" "main_db_endpoint" {
  private_endpoint_id           = azurerm_private_endpoint.main.id
  application_security_group_id = azurerm_application_security_group.main_db_endpoint.id
}
