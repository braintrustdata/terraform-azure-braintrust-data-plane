locals {
  gateway_subnet_cidr = cidrsubnets(var.vnet_address_space_cidr, 2)[1]

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

variable "gateway_subnet_cidr" {
  type        = string
  description = "CIDR block for the gateway subnet"
}

variable "database_subnet_cidr" {
  type        = string
  description = "CIDR block for the database subnet"
}

variable "services_subnet_cidr" {
  type        = string
  description = "CIDR block for the services subnet"
}
