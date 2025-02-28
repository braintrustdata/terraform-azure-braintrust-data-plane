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

## NETWORKING
variable "vnet_address_space" {
  type        = string
  default     = "10.175.0.0/16"
  description = "Address space for the VNet"
}

variable "enable_quarantine_vnet" {
  type        = bool
  description = "Enable the Quarantine VNet to run user defined functions in an isolated environment. If disabled, user defined functions will not be available."
  default     = true
}

variable "quarantine_vnet_address_space" {
  type        = string
  default     = "10.176.0.0/16"
  description = "Address space for the Quarantined VNet"
}

## Database
variable "postgres_sku_name" {
  description = "SKU name for the Azure Database for PostgreSQL instance."
  type        = string
  default     = "GP_Gen5_4"
}

variable "postgres_storage_mb" {
  description = "Storage size (in MB) for the Azure Database for PostgreSQL instance."
  type        = number
  default     = 102400 # 100 GB
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
