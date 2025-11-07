locals {
  # Calculate default subnet CIDRs from the VNet address space. # Carve out two subnets, one is half the vnet and the other is tiny
  calculated_subnet_cidrs = cidrsubnets(var.vnet_address_space_cidr, 1, 6, 6)
  # Example: 10.175.0.0/20 (4096 IPs)
  #   Subnet 1 range: 10.175.0.0/21 -> 10.175.0.0 - 10.175.7.255 (2048 IPs)
  #   Subnet 2 range: 10.175.8.0/26 -> 10.175.8.0 - 10.175.8.63 (64 IPs)

  # Example: 10.100.0.0/18 (16384 IPs)
  #   Subnet 1 range: 10.100.0.0/19 -> 10.100.0.0 - 10.100.3.255 (8192 IPs)
  #   Subnet 2 range: 10.100.4.0/24 -> 10.100.4.0 - 10.100.4.255 (256 IPs)
  #   Subnet 3 range: 10.100.5.0/24 -> 10.100.5.0 - 10.100.5.255 (256 IPs)
  default_services_subnet_cidr             = local.calculated_subnet_cidrs[0]
  default_private_endpoint_subnet_cidr     = local.calculated_subnet_cidrs[1]
  default_private_link_service_subnet_cidr = local.calculated_subnet_cidrs[2]

  # Use provided subnet CIDRs if given, otherwise use calculated defaults
  services_subnet_cidr             = var.services_subnet_cidr != null ? var.services_subnet_cidr : local.default_services_subnet_cidr
  private_endpoint_subnet_cidr     = var.private_endpoint_subnet_cidr != null ? var.private_endpoint_subnet_cidr : local.default_private_endpoint_subnet_cidr
  private_link_service_subnet_cidr = var.private_link_service_subnet_cidr != null ? var.private_link_service_subnet_cidr : local.default_private_link_service_subnet_cidr
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
}

variable "services_subnet_cidr" {
  type        = string
  description = "CIDR block for the services subnet"
  default     = null
}

variable "private_endpoint_subnet_cidr" {
  type        = string
  description = "CIDR block for the private endpoint subnet"
  default     = null
}

variable "private_link_service_subnet_cidr" {
  type        = string
  description = "CIDR block for the private link service subnet"
  default     = null
}

variable "enable_front_door" {
  type        = bool
  description = "Enable Private Link Service subnet (required for Azure Front Door)"
  default     = false
}
