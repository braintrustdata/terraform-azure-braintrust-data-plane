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
  description = "ID of the subnet to create the private endpoint in"
}

variable "virtual_network_id" {
  type        = string
  description = "ID of the virtual network to link with the private DNS zone"
}

variable "purge_protection_enabled" {
  type        = bool
  description = "Enable purge protection on the Key Vault. When enabled, deleted vaults cannot be purged during the retention period."
  default     = true
}

variable "custom_tags" {
  type        = map(string)
  description = "Additional tags to apply to all resources"
  default     = {}
}
