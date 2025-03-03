resource "azurerm_key_vault" "main" {
  name                = "${var.deployment_name}-kv"
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  sku_name = "standard"

  enabled_for_disk_encryption = true
  soft_delete_retention_days  = 7
  purge_protection_enabled    = true

  public_network_access_enabled = false
  network_acls {
    default_action             = "Deny"
    bypass                     = "AzureServices"
    ip_rules                   = []
    virtual_network_subnet_ids = var.allow_access_subnet_ids
  }

  enable_rbac_authorization = true

  tags = {
    deployment = var.deployment_name
  }
}

data "azurerm_client_config" "current" {}
