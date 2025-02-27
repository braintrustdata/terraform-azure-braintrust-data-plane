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
}

variable "postgres_version" {
  description = "PostgreSQL engine version for the Azure Database for PostgreSQL instance."
  type        = string
}

variable "vnet_name" {
  type        = string
  description = "Name of the virtual network"
}

variable "subnet_cidr" {
  type        = string
  description = "CIDR block for the subnet"
}

variable "key_vault_id" {
  type        = string
  description = "ID of the Key Vault"
}

variable "allowed_cidrs" {
  type        = list(string)
  description = "List of CIDRs to allow access to the database"
}
