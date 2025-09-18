variable "resource_group_name" {
  description = "The name of the resource group in which to create the storage account"
  type        = string
}

variable "deployment_name" {
  description = "The name of the deployment. Used for naming resources."
  type        = string
}

variable "location" {
  description = "The Azure Region in which to create the storage account"
  type        = string
}

variable "key_vault_id" {
  description = "The ID of the Key Vault to use for encryption"
  type        = string
}

variable "private_endpoint_subnet_id" {
  description = "The ID of the subnet to use for the private endpoint"
  type        = string
}

variable "vnet_id" {
  description = "The ID of the virtual network to link with the private DNS zone"
  type        = string
}

variable "create_storage_container" {
  description = "Create containers for the blobstorage. Defaults to true. Disable this if CI CD cannot reach the storage APIs."
  type        = bool
  default     = true
}

variable "blob_private_dns_zone_id" {
  description = "id of private dns zone for blob storage if it's already exists"
  type        = string
}