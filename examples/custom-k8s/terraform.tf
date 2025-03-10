terraform {
  required_version = ">= 1.10.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  # Store terraform state locally. Only use this for local testing.
  backend "local" {
    path = "terraform.tfstate"
  }

  # Example storing terraform state in Azure Blob Storage.
  # backend "azurerm" {
  #     resource_group_name  = "<your-resource-group-name>"
  #     storage_account_name = "<your-storage-account-name>"
  #     container_name       = "<your-container-name>"
  #     key                  = "braintrust.tfstate"
  # }
}
