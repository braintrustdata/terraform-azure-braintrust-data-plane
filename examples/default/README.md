# Braintrust Data Plane with AKS Automatic

This example demonstrates deploying a complete Braintrust data plane using **AKS Automatic** - Azure's fully-managed Kubernetes service (GA as of September 2025).

## What This Deploys

This example creates a production-ready Braintrust data plane with:

- **AKS Automatic Cluster** - Fully-managed Kubernetes with:
  - Automatic node scaling and provisioning
  - Built-in security and monitoring
  - Azure CNI Overlay networking (efficient IP usage)
  - Workload Identity for pod authentication
  - Key Vault CSI driver integration

- **PostgreSQL Flexible Server** - Main Braintrust database with:
  - Customer-managed encryption
  - Private endpoint connectivity
  - High availability configuration

- **Azure Cache for Redis** - Session and cache storage with:
  - Premium tier with zone redundancy
  - Private endpoint connectivity
  - TLS 1.2 encryption

- **Azure Blob Storage** - Object storage for AI models and function code with:
  - Premium BlockBlobStorage with ZRS
  - Private endpoint connectivity
  - Customer-managed encryption

- **Azure Key Vault** - Secrets and encryption key management

- **Virtual Network** - Isolated networking with dedicated subnets

## Prerequisites

1. **Azure CLI** installed and authenticated
   ```bash
   az login
   az account set --subscription "<your-subscription-id>"
   ```

2. **Terraform** >= 1.9.0 installed

3. **Braintrust License Key** - Get this from the Braintrust UI:
   - Go to Settings > Data Plane > Brainstore License Key

## Quick Start

### 1. Create a `terraform.tfvars` file

```hcl
azure_subscription_id  = "00000000-0000-0000-0000-000000000000"
braintrust_org_name    = "acme.com"
brainstore_license_key = "your-license-key-here"
deployment_name        = "braintrust"
location               = "eastus"
```

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Review the plan

```bash
terraform plan
```

### 4. Deploy

```bash
terraform apply
```

Deployment takes approximately **15-20 minutes**.

### 5. Connect to your cluster

```bash
az aks get-credentials --resource-group braintrust --name braintrust-aks
kubectl get nodes
```

## What is AKS Automatic?

AKS Automatic is Azure's fully-managed Kubernetes service that provides:

### Key Benefits

- ✅ **Zero Node Management** - Azure automatically provisions, scales, and manages nodes
- ✅ **Built-in Best Practices** - Security, networking, and monitoring configured automatically
- ✅ **Cost Optimization** - Intelligent scaling and right-sizing of resources
- ✅ **Simplified Operations** - Automatic upgrades and patching
- ✅ **Production Ready** - 99.95% SLA with Standard tier

### vs Traditional AKS

| Feature | Traditional AKS | AKS Automatic |
|---------|----------------|---------------|
| Node Pool Management | Manual | Automatic |
| Scaling Configuration | Manual | Automatic |
| VM Size Selection | Manual | Optimized by Azure |
| Security Baseline | Configure yourself | Built-in |
| Monitoring | Optional setup | Pre-configured |

## Customization Options

### Change Kubernetes Version

```hcl
module "braintrust" {
  # ...
  aks_kubernetes_version = "1.30"
}
```

### Set Maintenance Window

```hcl
module "braintrust" {
  # ...
  aks_maintenance_window_allowed = {
    day   = "Sunday"
    hours = [2, 3, 4, 5]  # 2 AM - 6 AM
  }
}
```

### Scale Database Resources

```hcl
module "braintrust" {
  # ...
  postgres_sku_name     = "MO_Standard_E4ds_v5"  # 4 vCores, 32 GB RAM
  postgres_storage_mb   = 262144                  # 256 GB
  postgres_storage_tier = "P30"
}
```

### Upgrade Redis to Premium

```hcl
module "braintrust" {
  # ...
  redis_sku_name = "Premium"
  redis_capacity = 2
}
```

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│ Resource Group: braintrust                              │
│                                                         │
│  ┌──────────────────────────────────────────────────┐ │
│  │ Virtual Network (10.190.0.0/16)                  │ │
│  │                                                   │ │
│  │  ┌────────────────────────────────────────────┐ │ │
│  │  │ Services Subnet                            │ │ │
│  │  │ - AKS Automatic Cluster                    │ │ │
│  │  │   - System node pool (auto-scaled)         │ │ │
│  │  │   - Workload Identity enabled              │ │ │
│  │  └────────────────────────────────────────────┘ │ │
│  │                                                   │ │
│  │  ┌────────────────────────────────────────────┐ │ │
│  │  │ Private Endpoint Subnet                    │ │ │
│  │  │ - PostgreSQL Private Endpoint              │ │ │
│  │  │ - Redis Private Endpoint                   │ │ │
│  │  │ - Blob Storage Private Endpoint            │ │ │
│  │  │ - Key Vault Private Endpoint               │ │ │
│  │  └────────────────────────────────────────────┘ │ │
│  └──────────────────────────────────────────────────┘ │
│                                                         │
│  ┌──────────────────────────────────────────────────┐ │
│  │ Data Services                                    │ │
│  │ - PostgreSQL Flexible Server                    │ │
│  │ - Azure Cache for Redis                         │ │
│  │ - Azure Blob Storage                            │ │
│  │ - Azure Key Vault                               │ │
│  └──────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────┘
```

## Cost Estimate

Approximate monthly costs (East US region):

| Resource | Configuration | Monthly Cost |
|----------|--------------|--------------|
| AKS Automatic | Standard tier | ~$73 |
| AKS Nodes | System pool (3x D2as_v6) | ~$150 |
| PostgreSQL | E2ds_v5, 128GB | ~$250 |
| Redis | Standard C1 | ~$20 |
| Storage | Premium Block Blob | ~$50 |
| Key Vault | Standard | ~$5 |
| **Total** | | **~$548/month** |

*Costs vary based on actual usage and region. Node costs increase with workload scaling.*

## Security Features

- ✅ All data encrypted at rest with customer-managed keys
- ✅ All network traffic over private endpoints
- ✅ Workload Identity for pod-to-Azure authentication (no secrets)
- ✅ RBAC enabled on AKS cluster
- ✅ TLS 1.2+ for all connections
- ✅ Azure Monitor integration
- ✅ Network Security Groups on all subnets

## Next Steps

After deployment:

1. **Deploy Braintrust Helm Chart** to the AKS cluster
2. **Configure DNS** to point to your cluster
3. **Set up CI/CD** for automated deployments
4. **Configure monitoring** and alerting
5. **Review security posture** in Azure Security Center

## Cleanup

To destroy all resources:

```bash
terraform destroy
```

⚠️ **Warning**: This will permanently delete all data including databases and storage accounts.

## Troubleshooting

### AKS cluster not accessible

```bash
# Verify cluster is running
az aks show --resource-group braintrust --name braintrust-aks --query provisioningState

# Get fresh credentials
az aks get-credentials --resource-group braintrust --name braintrust-aks --overwrite-existing
```

### Database connection issues

Check that your application pods have the correct workload identity annotations and that the managed identity has the proper Key Vault permissions.

## Support

For issues with:
- **This Terraform module**: Open an issue in this repository
- **Braintrust platform**: Contact Braintrust support
- **Azure services**: Contact Azure support
