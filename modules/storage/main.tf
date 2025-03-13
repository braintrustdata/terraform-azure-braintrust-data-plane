locals {
  # Names are highly restrictive for storage accounts. So we have to use a random suffix.
  # Max 24 chars. Letters & numbers ONLY
  storage_account_name  = "btstorage${random_string.storage_account_suffix.result}"
  key_name              = "${var.deployment_name}-storage-key"
  private_dns_zone_name = "privatelink.blob.core.windows.net"
}

resource "random_string" "storage_account_suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_key_vault_key" "storage" {
  name         = local.key_name
  key_vault_id = var.key_vault_id
  key_type     = "RSA"
  key_size     = 4096
  key_opts     = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]
}

resource "azurerm_user_assigned_identity" "storage" {
  name                = "${var.deployment_name}-${local.storage_account_name}-id"
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_key_vault_access_policy" "storage_identity" {
  key_vault_id = var.key_vault_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.storage.principal_id

  key_permissions = [
    "Get",
    "UnwrapKey",
    "WrapKey"
  ]
}

resource "azurerm_storage_account" "main" {
  name                       = local.storage_account_name
  resource_group_name        = var.resource_group_name
  location                   = var.location
  account_tier               = "Premium"
  account_replication_type   = "ZRS"
  access_tier                = "Hot"
  min_tls_version            = "TLS1_2"
  https_traffic_only_enabled = true

  infrastructure_encryption_enabled = false
  shared_access_key_enabled         = false
  public_network_access_enabled     = true
  blob_properties {
    versioning_enabled  = false
    change_feed_enabled = false
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.storage.id]
  }

  customer_managed_key {
    key_vault_key_id          = azurerm_key_vault_key.storage.id
    user_assigned_identity_id = azurerm_user_assigned_identity.storage.id
  }

  depends_on = [
    azurerm_key_vault_access_policy.storage_identity
  ]
}

resource "azurerm_storage_container" "brainstore" {
  name                  = "brainstore"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "lambda_responses" {
  name                  = "lambda-responses"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "code_bundles" {
  name                  = "code-bundles"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

resource "azurerm_private_dns_zone" "blob" {
  name                = local.private_dns_zone_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "blob" {
  name                  = "${local.storage_account_name}-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.blob.name
  virtual_network_id    = var.vnet_id
}

resource "azurerm_private_endpoint" "storage" {
  name                = "${local.storage_account_name}-endpoint"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${local.storage_account_name}-connection"
    private_connection_resource_id = azurerm_storage_account.main.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }
  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.blob.id]
  }

  depends_on = [
    azurerm_private_dns_zone.blob,
    azurerm_private_dns_zone_virtual_network_link.blob
  ]
}

data "azurerm_client_config" "current" {}
