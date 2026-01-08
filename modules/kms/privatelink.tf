resource "azurerm_private_endpoint" "key_vault" {
  name                = "${var.deployment_name}-kv-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id
  tags                = local.tags

  private_service_connection {
    name                           = "${var.deployment_name}-kv-psc"
    private_connection_resource_id = azurerm_key_vault.main.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }

  private_dns_zone_group {
    name                 = var.deployment_name
    private_dns_zone_ids = [azurerm_private_dns_zone.key_vault.id]
  }
}

resource "azurerm_private_dns_zone" "key_vault" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = var.resource_group_name
  tags                = local.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "key_vault" {
  name                  = "${var.deployment_name}-kv-pdzvnetlink"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.key_vault.name
  virtual_network_id    = var.virtual_network_id
  tags                  = local.tags
}

resource "azurerm_application_security_group" "main_kv_endpoint" {
  name                = "${var.deployment_name}-kv"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = local.tags
}

resource "azurerm_private_endpoint_application_security_group_association" "main_kv_endpoint" {
  private_endpoint_id           = azurerm_private_endpoint.key_vault.id
  application_security_group_id = azurerm_application_security_group.main_kv_endpoint.id
}
