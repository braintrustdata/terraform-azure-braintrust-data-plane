resource "azurerm_user_assigned_identity" "brainstore" {
  name                = "brainstore-identity"
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_role_assignment" "brainstore_storage_contributor" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.brainstore.principal_id
}

resource "azurerm_user_assigned_identity" "api-handler" {
  name                = "api-handler-identity"
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_role_assignment" "api-handler_storage_contributor" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.api-handler.principal_id
}
