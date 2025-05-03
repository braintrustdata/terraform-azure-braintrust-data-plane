output "storage_account_id" {
  description = "The ID of the storage account"
  value       = azurerm_storage_account.main.id
}

output "storage_account_name" {
  description = "The name of the storage account"
  value       = azurerm_storage_account.main.name
}

output "primary_blob_endpoint" {
  description = "The primary blob endpoint URL"
  value       = azurerm_storage_account.main.primary_blob_endpoint
}

output "brainstore_container_name" {
  description = "The name of the brainstore container"
  value       = var.create_storage_container ? azurerm_storage_container.brainstore[0].name : ""
}

output "responses_container_name" {
  description = "The name of the responses container"
  value       = var.create_storage_container ? azurerm_storage_container.responses[0].name : ""
}

output "code_bundles_container_name" {
  description = "The name of the code-bundles container"
  value       = var.create_storage_container ? azurerm_storage_container.code_bundles[0].name : ""
}

output "storage_identity_id" {
  description = "The ID of the user-assigned managed identity used by the storage account"
  value       = azurerm_user_assigned_identity.storage.id
}

output "storage_identity_principal_id" {
  description = "The principal ID of the user-assigned managed identity used by the storage account"
  value       = azurerm_user_assigned_identity.storage.principal_id
}

output "connection_string" {
  description = "Connection string for use with Azure AD authentication (no account key)"
  value       = azurerm_key_vault_secret.azure-storage-connection-string.value
}

output "connection_string_secret_name" {
  description = "The name of the secret containing the connection string"
  value       = azurerm_key_vault_secret.azure-storage-connection-string.name
}
