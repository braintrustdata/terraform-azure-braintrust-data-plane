terraform {
  required_version = ">= 1.9.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.27.0"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
  subscription_id     = var.azure_subscription_id
  storage_use_azuread = true
}

# Deploy complete Braintrust data plane
module "braintrust" {
  source = "../.."

  # Organization settings
  braintrust_org_name    = var.braintrust_org_name
  brainstore_license_key = var.brainstore_license_key

  # Deployment configuration
  deployment_name = var.deployment_name
  location        = var.location

  # AKS configuration
  create_aks_cluster = true

  enable_front_door                                  = var.enable_front_door
  front_door_api_backend_address                     = var.front_door_api_backend_address
  front_door_load_balancer_frontend_ip_config_id     = var.front_door_load_balancer_frontend_ip_config_id

}
