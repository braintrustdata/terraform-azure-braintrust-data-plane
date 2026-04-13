# Braintrust Azure Data Plane - Terraform Module

This is a Terraform module that provisions Azure infrastructure for the Braintrust hybrid data plane on Azure Kubernetes Service.

## Module Structure

```
├── main.tf, variables.tf, outputs.tf, data.tf, versions.tf   # Root module - orchestrates submodules
├── modules/
│   ├── database/       # Azure Flexible PostgreSQL + private endpoint + CMK
│   ├── front_door/     # Azure Front Door Premium + Private Link Service (optional)
│   ├── k8s/            # AKS cluster + node pools + Workload Identity federation
│   ├── kms/            # Azure Key Vault + private endpoint
│   ├── redis/          # Azure Cache for Redis + private endpoint
│   ├── storage/        # Storage account + blob containers + CMK + managed identity
│   └── vnet/           # VNet, subnets, NSGs, private DNS zones
├── examples/
│   └── default/        # Production example
└── moved.tf            # State migration for resource group refactor
```

### Key architecture concepts

- **Pure infrastructure module.** This module creates VNet, AKS, PostgreSQL, Redis, Azure Storage, Key Vault, and optionally Azure Front Door. It does not manage application-level configuration (environment variables, image tags, etc.). All application config lives in the Helm chart deployed on top of this infrastructure.
- **`deployment_name`** prefixes all resource names and must be unique per deployment.
- **Single storage account with three containers:** `brainstore` (index, WAL, locks), `responses` (response cache, shared with API layer), `code-bundles`. The `responses` container is shared between the API and Brainstore - the Helm chart isolates Brainstore data under a `/brainstore-cache` subpath.
- **Workload Identity** uses AKS OIDC + federated credentials. Both the `braintrust-api` and `brainstore` Kubernetes service accounts have federated credentials registered against a single managed identity with `Storage Blob Data Contributor` on the storage account.
- **Azure Front Door** is optional and requires a two-phase deployment: first apply creates infra, second apply (after Helm) enables Front Door. The Private Link Service connection requires manual portal approval.

## Critical Safety Constraints

### Storage Container Naming

The three blob containers (`brainstore`, `responses`, `code-bundles`) are referenced by name in Helm chart values. Renaming or recreating containers would orphan existing data. The `responses` container is shared between the API layer and Brainstore cache - the Helm chart manages subpath isolation.

### Front Door Routes

Unlike AWS API Gateway (which has an explicit route allowlist), Azure Front Door routes `/*` to the backend. No route-level changes are needed when new application endpoints are added.
