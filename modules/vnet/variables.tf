locals {
  default_vnet_address_space           = "10.175.0.0/20"                                    # 4096 IP addresses
  default_services_subnet_cidr         = cidrsubnet(local.default_vnet_address_space, 2, 0) # 1024 IP addresses
  default_database_subnet_cidr         = cidrsubnet(local.default_vnet_address_space, 7, 1) # 32 IP addresses
  default_gateway_subnet_cidr          = cidrsubnet(local.default_vnet_address_space, 7, 2) # 32 IP addresses
  default_redis_subnet_cidr            = cidrsubnet(local.default_vnet_address_space, 7, 3) # 32 IP addresses
  default_private_endpoint_subnet_cidr = cidrsubnet(local.default_vnet_address_space, 7, 4) # 32 IP addresses

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
