# Braintrust Data Plane for Azure

This Terraform module deploys the Braintrust data plane on Azure. It creates all the necessary core infrastructure to run Braintrust in your own Azure subscription.

After spinning up the data plane, you will need to deploy the Braintrust services to the AKS cluster using the [Braintrust Helm chart](https://github.com/braintrustdata/helm/tree/main/braintrust).

## Resources

This module creates the following resources by default:
- Virtual Network
- Azure Key Vault for encryption and secrets management
- Azure Database for PostgreSQL
- Azure Cache for Redis
- Azure Storage Account for blob storage
- AKS Kubernetes Cluster

The VNet and AKS cluster can be optionally disabled so you can bring your own network and cluster.

## Usage

```hcl
module "braintrust_data_plane" {
  source = "github.com/braintrust-ai/terraform-azure-braintrust-data-plane"

  braintrust_org_name = "your-org-name"
  deployment_name     = "braintrust"
  location            = "eastus2"
  create_aks_cluster  = true
}
```
