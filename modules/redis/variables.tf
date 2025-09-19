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

variable "private_endpoint_subnet_id" {
  type        = string
  description = "ID of the subnet for Redis private endpoint"
}

variable "redis_sku_name" {
  type        = string
  description = "SKU name for the Azure Cache for Redis instance"
  default     = "Standard"
}

variable "redis_family" {
  type        = string
  description = "Family for the Azure Cache for Redis instance. C for standard, P for premium"
  default     = "C"
}

variable "redis_capacity" {
  type        = number
  description = "Capacity for the Azure Cache for Redis instance"
  default     = 1
}

variable "redis_version" {
  type        = string
  description = "Redis engine version"
  default     = "6"
}

variable "virtual_network_id" {
  type        = string
  description = "ID of the virtual network"
}

variable "key_vault_id" {
  description = "The ID of the Key Vault where Redis secrets will be stored"
  type        = string
}

variable "existing_redis_private_dns_zone_id" {
  description = "Advanced: Use an existing private dns zone id for redis private endpoint. Only needed if you want to deploy two data planes into the same VNet. Leave blank to auto-create one."
  type        = string
  default     = ""
}
