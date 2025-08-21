variable "braintrust_org_name" {
  type        = string
  description = "The name of your organization in Braintrust (e.g. acme.com)"
}

variable "deployment_name" {
  type        = string
  default     = "braintrust"
  description = "Name of this Braintrust deployment. Will be included in tags and prefixes in resources names. Lowercase letter, numbers, and hyphens only. If you want multiple deployments in your same Azure subscription, use a unique name for each deployment."
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.deployment_name))
    error_message = "The deployment_name must contain only lowercase letters, numbers and hyphens in order to be compatible with Azure resource naming restrictions."
  }
  validation {
    condition     = length(var.deployment_name) <= 18
    error_message = "The deployment_name must be 18 characters or less."
  }
}

variable "location" {
  type        = string
  description = "Azure region to deploy resources to"
}

variable "key_vault_id" {
  description = "Existing Key Vault ID to use for encrypting resources. If not provided, a new Key Vault will be created. DO NOT change this after deployment."
  type        = string
  default     = null
}

variable "brainstore_license_key" {
  type        = string
  description = "The license key for the Brainstore instance. You can find this in the Braintrust UI under Settings > Data Plane > Brainstore License Key."
}

## NETWORKING

variable "existing_vnet" {
  type = object({
    id                                         = string
    name                                       = string
    services_subnet_id                         = string
    private_endpoint_subnet_id                 = string
    private_endpoint_network_security_group_id = string
    address_space                              = string
  })
  default = {
    id                                         = ""
    name                                       = ""
    services_subnet_id                         = ""
    private_endpoint_subnet_id                 = ""
    private_endpoint_network_security_group_id = ""
    address_space                              = ""
  }
}


variable "vnet_address_space_cidr" {
  type        = string
  description = "Address space for the VNet"
  default     = null
}

variable "services_subnet_cidr" {
  description = "CIDR block for the services subnet. Leave blank to auto-calculate one."
  type        = string
  default     = null
}

variable "private_endpoint_subnet_cidr" {
  description = "CIDR block for the private endpoint subnet. Leave blank to auto-calculate one."
  type        = string
  default     = null
}

## AKS
variable "create_aks_cluster" {
  description = "Create an AKS cluster"
  type        = bool
  default     = true
}

variable "aks_system_vm_size" {
  description = "VM size for the system nodes"
  type        = string
  default     = "Standard_D2as_v6"
}

variable "aks_user_vm_size" {
  description = "VM size for the user nodes that run the application. Must be a SKU with a temporary local storage SSD."
  type        = string
  default     = "Standard_D16ds_v6"
}


## Database
variable "postgres_sku_name" {
  description = "SKU name for the Azure Database for PostgreSQL instance."
  type        = string
  default     = "MO_Standard_E2ds_v5"
}

variable "postgres_storage_mb" {
  description = "Storage size (in MB) for the Azure Database for PostgreSQL instance."
  type        = number
  default     = 131072
}

variable "postgres_storage_tier" {
  description = "Storage tier for the Azure Database for PostgreSQL instance."
  type        = string
  default     = "P20"
}

variable "postgres_version" {
  description = "PostgreSQL engine version for the Azure Database for PostgreSQL instance."
  type        = string
  default     = "15"
}

## Redis
variable "redis_sku_name" {
  description = "SKU name for the Azure Cache for Redis instance"
  type        = string
  default     = "Standard"
}

variable "redis_family" {
  description = "Family for the Azure Cache for Redis instance"
  type        = string
  default     = "C"
}

variable "redis_capacity" {
  description = "Capacity for the Azure Cache for Redis instance"
  type        = number
  default     = 1
}

variable "redis_version" {
  description = "Redis engine version"
  type        = string
  default     = "6"
}

## Storage
variable "create_storage_container" {
  description = "Create containers for the blobstorage. Defaults to true. Disable this if CI CD cannot reach the storage APIs."
  type        = bool
  default     = true
}
