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

variable "subnet_id" {
  type        = string
  description = "ID of the subnet for Redis"
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
