output "brainstore_identity_client_id" {
  description = "Client ID of the brainstore managed identity"
  value       = azurerm_user_assigned_identity.brainstore.client_id
}

output "brainstore_identity_principal_id" {
  description = "Principal ID of the brainstore managed identity"
  value       = azurerm_user_assigned_identity.brainstore.principal_id
}

output "brainstore_identity_id" {
  description = "ID of the brainstore managed identity"
  value       = azurerm_user_assigned_identity.brainstore.id
}

output "api_handler_identity_client_id" {
  description = "Client ID of the api-handler managed identity"
  value       = azurerm_user_assigned_identity.api-handler.client_id
}

output "api_handler_identity_principal_id" {
  description = "Principal ID of the api-handler managed identity"
  value       = azurerm_user_assigned_identity.api-handler.principal_id
}

output "api_handler_identity_id" {
  description = "ID of the api-handler managed identity"
  value       = azurerm_user_assigned_identity.api-handler.id
}

