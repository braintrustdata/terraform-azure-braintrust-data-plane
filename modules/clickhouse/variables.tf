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

variable "clickhouse_instance_count" {
  type        = number
  description = "Number of Clickhouse instances to deploy"
  default     = 1
}

variable "clickhouse_vm_size" {
  type        = string
  description = "VM size for the Clickhouse instance"
}

variable "clickhouse_data_disk_size_gb" {
  type        = number
  description = "Size of the data disk for Clickhouse in GB"
}

variable "subnet_id" {
  type        = string
  description = "ID of the subnet for Clickhouse"
}

variable "vnet_id" {
  type        = string
  description = "ID of the virtual network"
}

variable "key_vault_id" {
  type        = string
  description = "ID of the Key Vault"
}
