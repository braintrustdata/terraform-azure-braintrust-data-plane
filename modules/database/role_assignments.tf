
resource "azurerm_role_assignment" "postgres_cmk_crypto_service_encryption_user" {
  scope                = azurerm_key_vault_key.postgres_cmk.id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_user_assigned_identity.postgres_cmk.principal_id
}
