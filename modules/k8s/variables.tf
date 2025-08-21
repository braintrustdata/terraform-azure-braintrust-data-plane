variable "resource_group_name" {
  description = "Name of the resource group"
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

variable "vm_size" {
  description = "VM size for the nodes"
  type        = string
  default     = "Standard_D16ds_v6"
}

variable "vnet_name" {
  description = "Name of the existing VNet"
  type        = string
}

variable "services_subnet_id" {
  description = "ID of the subnet for AKS"
  type        = string
}

variable "system_vm_size" {
  description = "VM size for the system nodes"
  type        = string
  default     = "Standard_D2as_v6"
}

