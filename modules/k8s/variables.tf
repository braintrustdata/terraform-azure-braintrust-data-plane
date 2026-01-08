variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "resource_group_id" {
  description = "ID of the resource group"
  type        = string
}

variable "deployment_name" {
  description = "Name of the deployment"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
  default     = "aks"
}

variable "brainstore_pool_vm_size" {
  description = "VM size for the brainstore node pool"
  type        = string
  default     = "Standard_D32ds_v6"
}

variable "brainstore_pool_max_count" {
  description = "Maximum number of nodes in the brainstore pool"
  type        = number
  default     = 10
}

variable "brainstore_pool_min_count" {
  description = "Minimum number of nodes in the brainstore pool"
  type        = number
  default     = 2
}

variable "services_pool_vm_size" {
  description = "VM size for the services node pool"
  type        = string
  default     = "Standard_D16s_v6"
}

variable "services_pool_max_count" {
  description = "Maximum number of nodes in the services pool"
  type        = number
  default     = 10
}

variable "services_pool_min_count" {
  description = "Minimum number of nodes in the services pool"
  type        = number
  default     = 2
}

variable "services_subnet_id" {
  description = "ID of the subnet for AKS"
  type        = string
}

variable "system_pool_vm_size" {
  description = "VM size for the system nodes"
  type        = string
  default     = "Standard_D2as_v6"
}

variable "key_vault_id" {
  description = "ID of the Key Vault to grant access to"
  type        = string
}

variable "storage_account_id" {
  description = "ID of the Storage Account to grant access to"
  type        = string
}

variable "custom_tags" {
  type        = map(string)
  description = "Additional tags to apply to all resources"
  default     = {}
}
