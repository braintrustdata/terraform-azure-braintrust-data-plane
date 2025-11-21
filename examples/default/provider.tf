provider "azurerm" {
  subscription_id = "<your-azure-subscription-id>"
  tenant_id       = "<your-azure-tenant-id>"
  features {
    postgresql_flexible_server {
      # Don't restart when static server parameters change
      restart_server_on_configuration_value_change = false
    }
  }
  # Required to enable AKS extensions like Container Storage
  resource_providers_to_register = ["Microsoft.KubernetesConfiguration"]
  # Required when disabling Shared Key Authorisation
  storage_use_azuread = true
}
