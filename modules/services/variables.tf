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

variable "braintrust_org_name" {
  type        = string
  description = "The name of your organization in Braintrust"
}

# Database settings
variable "postgres_host" {
  type        = string
  description = "PostgreSQL host"
}

variable "postgres_port" {
  type        = number
  description = "PostgreSQL port"
}

variable "postgres_username" {
  type        = string
  description = "PostgreSQL username"
}

variable "postgres_password" {
  type        = string
  description = "PostgreSQL password"
  sensitive   = true
}

# Redis settings
variable "redis_host" {
  type        = string
  description = "Redis host"
}

variable "redis_port" {
  type        = number
  description = "Redis port"
}

variable "redis_password" {
  type        = string
  description = "Redis password"
  sensitive   = true
}

# Clickhouse settings
variable "clickhouse_host" {
  type        = string
  description = "Clickhouse host"
  default     = null
}

variable "clickhouse_secret_id" {
  type        = string
  description = "Clickhouse secret ID"
  default     = null
}

# Service configuration
variable "api_handler_scale_out_capacity" {
  type        = number
  description = "The number of API Handler instances to provision and keep alive"
}

variable "whitelisted_origins" {
  type        = list(string)
  description = "List of origins to whitelist for CORS"
}

variable "outbound_rate_limit_window_minutes" {
  type        = number
  description = "The time frame in minutes over which rate per-user rate limits are accumulated"
}

variable "outbound_rate_limit_max_requests" {
  type        = number
  description = "The maximum number of requests per user allowed in the time frame"
}

variable "custom_domain" {
  type        = string
  description = "Custom domain name for the Front Door distribution"
  default     = null
}

variable "custom_certificate_id" {
  type        = string
  description = "ID of the certificate for the custom domain"
  default     = null
}

# Networking
variable "vnet_id" {
  type        = string
  description = "ID of the virtual network"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for the services"
}

# Quarantine VNet
variable "use_quarantine_vnet" {
  type        = bool
  description = "Whether to use the quarantine VNet"
}

variable "quarantine_vnet_id" {
  type        = string
  description = "ID of the quarantine VNet"
  default     = null
}

variable "quarantine_vnet_subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs in the quarantine VNet"
  default     = []
}

variable "key_vault_id" {
  type        = string
  description = "ID of the Key Vault"
}
