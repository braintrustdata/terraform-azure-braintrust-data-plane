locals {
  default_vnet_address_space           = "10.175.0.0/20"                                     # 4096 IP addresses
  default_services_subnet_cidr         = cidrsubnet(local.default_vnet_address_space, 2, 0)  # 1024 IP addresses (x.x.0.0/22)
  default_database_subnet_cidr         = cidrsubnet(local.default_vnet_address_space, 7, 32) # 32 IP addresses (x.x.4.0/27)
  default_gateway_subnet_cidr          = cidrsubnet(local.default_vnet_address_space, 7, 33) # 32 IP addresses (x.x.4.32/27)
  default_redis_subnet_cidr            = cidrsubnet(local.default_vnet_address_space, 7, 34) # 32 IP addresses (x.x.4.64/27)
  default_private_endpoint_subnet_cidr = cidrsubnet(local.default_vnet_address_space, 7, 35) # 32 IP addresses (x.x.4.96/27)

  vnet_address_space_cidr      = var.vnet_address_space_cidr != null ? var.vnet_address_space_cidr : local.default_vnet_address_space
  services_subnet_cidr         = var.services_subnet_cidr != null ? var.services_subnet_cidr : local.default_services_subnet_cidr
  database_subnet_cidr         = var.database_subnet_cidr != null ? var.database_subnet_cidr : local.default_database_subnet_cidr
  gateway_subnet_cidr          = var.gateway_subnet_cidr != null ? var.gateway_subnet_cidr : local.default_gateway_subnet_cidr
  redis_subnet_cidr            = var.redis_subnet_cidr != null ? var.redis_subnet_cidr : local.default_redis_subnet_cidr
  private_endpoint_subnet_cidr = var.private_endpoint_subnet_cidr != null ? var.private_endpoint_subnet_cidr : local.default_private_endpoint_subnet_cidr
}

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

variable "vnet_name" {
  type        = string
  description = "Name of the virtual network"
}

variable "vnet_address_space_cidr" {
  type        = string
  description = "CIDR block for the VNet"
  default     = null
}

variable "gateway_subnet_cidr" {
  type        = string
  description = "CIDR block for the gateway subnet"
  default     = null
}

variable "database_subnet_cidr" {
  type        = string
  description = "CIDR block for the database subnet"
  default     = null
}

variable "services_subnet_cidr" {
  type        = string
  description = "CIDR block for the services subnet"
  default     = null
}

variable "redis_subnet_cidr" {
  type        = string
  description = "CIDR block for the redis subnet"
  default     = null
}

variable "private_endpoint_subnet_cidr" {
  type        = string
  description = "CIDR block for the private endpoint subnet"
  default     = null
}
