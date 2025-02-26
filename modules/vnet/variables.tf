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

variable "vnet_address_space" {
  type        = string
  description = "Address space for the VNet"
}

variable "public_subnet_cidr" {
  type        = string
  description = "CIDR block for the public subnet"
}

variable "private_subnet_1_cidr" {
  type        = string
  description = "CIDR block for the first private subnet"
}

variable "private_subnet_2_cidr" {
  type        = string
  description = "CIDR block for the second private subnet"
}

variable "private_subnet_3_cidr" {
  type        = string
  description = "CIDR block for the third private subnet"
}
