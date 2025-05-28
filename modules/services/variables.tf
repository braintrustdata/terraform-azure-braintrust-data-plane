variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "storage_account_id" {
  description = "ID of the storage account to grant access to"
  type        = string
}
