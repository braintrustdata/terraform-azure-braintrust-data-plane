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
}

variable "redis_family" {
  type        = string
  description = "Family for the Azure Cache for Redis instance"
}

variable "redis_capacity" {
  type        = number
  description = "Capacity for the Azure Cache for Redis instance"
}

variable "redis_version" {
  type        = string
  description = "Redis engine version"
}
