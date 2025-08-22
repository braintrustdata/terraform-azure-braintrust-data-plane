locals {
  # Names are highly restrictive for storage accounts. So we have to use a random suffix.
  # Max 24 chars. Letters & numbers ONLY
  storage_account_name            = "btstorage${random_string.storage_account_suffix.result}"
  key_name                        = "${var.deployment_name}-storage-key"
  private_dns_zone_name           = "privatelink.blob.core.windows.net"
  connection_string_secret_name   = "azure-storage-connection-string"
  azure_storage_connection_string = "BlobEndpoint=${azurerm_storage_account.main.primary_blob_endpoint};"
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

resource "azurerm_role_assignment" "storage_cmk" {
  for_each = toset([
    "Key Vault Crypto User",
    "Key Vault Crypto Service Encryption User"
  ])
  scope                = var.key_vault_id
  role_definition_name = each.value
  principal_id         = azurerm_user_assigned_identity.storage.principal_id
  principal_type       = "ServicePrincipal"
}

resource "azurerm_storage_account" "main" {
  name                       = local.storage_account_name
  resource_group_name        = var.resource_group_name
  location                   = var.location
  account_tier               = "Premium"
  account_replication_type   = "ZRS"
  account_kind               = "BlockBlobStorage"
  min_tls_version            = "TLS1_2"
  https_traffic_only_enabled = true

  infrastructure_encryption_enabled = false
  shared_access_key_enabled         = false
  public_network_access_enabled     = true
  allow_nested_items_to_be_public   = false
  blob_properties {
    versioning_enabled  = false
    change_feed_enabled = false
    cors_rule {
      allowed_headers    = ["*"]
      allowed_methods    = ["GET", "PUT", "HEAD"]
      allowed_origins    = ["https://braintrust.dev", "https://*.braintrust.dev", "https://*.preview.braintrust.dev"]
      exposed_headers    = ["*"]
      max_age_in_seconds = 3600
    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.storage.id]
  }

  customer_managed_key {
    key_vault_key_id          = azurerm_key_vault_key.storage.id
    user_assigned_identity_id = azurerm_user_assigned_identity.storage.id
  }

}

resource "azurerm_storage_container" "brainstore" {
  count = var.create_storage_container ? 1 : 0

  name                  = "brainstore"
  storage_account_id    = azurerm_storage_account.main.id
  container_access_type = "private"
}

resource "azurerm_storage_container" "responses" {
  count = var.create_storage_container ? 1 : 0

  name                  = "responses"
  storage_account_id    = azurerm_storage_account.main.id
  container_access_type = "private"
}

resource "azurerm_storage_container" "code_bundles" {
  count = var.create_storage_container ? 1 : 0

  name                  = "code-bundles"
  storage_account_id    = azurerm_storage_account.main.id
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

resource "azurerm_key_vault_secret" "azure-storage-connection-string" {
  # Note: This does not actually contain a secret account key. It is stored in the key vault as a secret only because
  # Helm expects it to be a secret. There may be cases where customers do not use our terraform module and they
  # create their own storage account that uses a static account key. So we must assume this string is a secret.
  name         = "azure-storage-connection-string"
  value        = local.azure_storage_connection_string
  key_vault_id = var.key_vault_id
}

