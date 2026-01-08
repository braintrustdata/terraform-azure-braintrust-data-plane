
resource "azurerm_user_assigned_identity" "main" {
  name                = "${local.db_name}-identity"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = local.tags
}

resource "azurerm_role_assignment" "crypto_service_encryption_user" {
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_user_assigned_identity.main.principal_id
}
