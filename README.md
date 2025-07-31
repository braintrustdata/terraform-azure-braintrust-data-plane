# Braintrust Data Plane for Azure

This Terraform module deploys the Braintrust data plane on Azure. It creates all the necessary infrastructure to run Braintrust in your own Azure subscription.

## Architecture

This module creates the following resources:
- Azure Resource Group
- Virtual Networks (Main and Quarantine)
- Azure Database for PostgreSQL
- Azure Cache for Redis
- Azure App Service for API handlers
- Azure Key Vault for secrets management

## Usage

```hcl
module "braintrust_data_plane" {
  source = "github.com/braintrust-ai/terraform-azure-braintrust-data-plane"

  braintrust_org_name = "your-org-name"
  deployment_name     = "braintrust"
  location            = "eastus2"
}
```
