variable "deployment_name" {
  type        = string
  description = "Name of the Braintrust deployment"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region to deploy resources to"
}

variable "postgres_sku_name" {
  description = "SKU name for the Azure Database for PostgreSQL instance."
  type        = string
}

variable "postgres_storage_tier" {
  type        = string
  description = "Storage tier for the Azure Database for PostgreSQL instance."
}
variable "postgres_storage_mb" {
  description = "Storage size (in MB) for the Azure Database for PostgreSQL instance."
  type        = number
  validation {
    # Azure enforces this, not us.
    condition     = contains([32768, 65536, 131072, 262144, 524288, 1048576, 2097152, 4193280, 4194304, 8388608, 16777216, 33553408], var.postgres_storage_mb)
    error_message = "Storage size must be one of: 32768, 65536, 131072, 262144, 524288, 1048576, 2097152, 4193280, 4194304, 8388608, 16777216, or 33553408 MB."
  }
}

variable "postgres_version" {
  description = "PostgreSQL engine version for the Azure Database for PostgreSQL instance."
  type        = string
  default     = "16"
}

variable "vnet_id" {
  type        = string
  description = "ID of the virtual network"
}

variable "private_endpoint_subnet_id" {
  type        = string
  description = "ID of the subnet to create the private endpoint in"
}

variable "key_vault_id" {
  description = "The ID of the Key Vault to use for database encryption and secrets"
  type        = string
}

variable "existing_postgres_private_dns_zone_id" {
  description = "Advanced: Use an existing private dns zone id for postgres private endpoint. Only needed if you want to deploy two data planes into the same VNet. Leave blank to auto-create one."
  type        = string
  default     = ""
}

variable "custom_tags" {
  type        = map(string)
  description = "Additional tags to apply to all resources"
  default     = {}
}
