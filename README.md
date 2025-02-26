# Braintrust Data Plane for Azure

NOTE: This module is not production ready. It is a work in progress and actively being developed.

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

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| azurerm | >= 3.0.0 |
| random | >= 3.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| braintrust_org_name | The name of your organization in Braintrust (e.g. acme.com) | `string` | n/a | yes |
| deployment_name | Name of this Braintrust deployment | `string` | `"braintrust"` | no |
| location | Azure region to deploy resources to | `string` | n/a | yes |
| key_vault_id | Existing Key Vault ID to use for encrypting resources | `string` | `null` | no |
| vnet_address_space | Address space for the VNet | `string` | `"10.175.0.0/16"` | no |
| enable_quarantine_vnet | Enable the Quarantine VNet | `bool` | `true` | no |
| quarantine_vnet_address_space | Address space for the Quarantined VNet | `string` | `"10.176.0.0/16"` | no |
| postgres_sku_name | SKU name for the Azure Database for PostgreSQL instance | `string` | `"GP_Gen5_4"` | no |
| postgres_storage_mb | Storage size (in MB) for the Azure Database for PostgreSQL instance | `number` | `102400` | no |
| postgres_version | PostgreSQL engine version | `string` | `"15"` | no |
| redis_sku_name | SKU name for the Azure Cache for Redis instance | `string` | `"Standard"` | no |
| redis_family | Family for the Azure Cache for Redis instance | `string` | `"C"` | no |
| redis_capacity | Capacity for the Azure Cache for Redis instance | `number` | `1` | no |
| redis_version | Redis engine version | `string` | `"6"` | no |
| api_handler_scale_out_capacity | The number of API Handler instances to provision | `number` | `0` | no |


## Outputs

| Name | Description |
|------|-------------|
| resource_group_name | Name of the resource group containing Braintrust resources |
| main_vnet_id | ID of the main VNet that contains the Braintrust resources |
| api_url | The primary endpoint for the dataplane API |
| postgres_database_id | ID of the main Braintrust Postgres database |
| redis_id | ID of the Redis instance |
