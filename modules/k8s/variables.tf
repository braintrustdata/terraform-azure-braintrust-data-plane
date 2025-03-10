variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
  default     = "aks-small-prod"
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.28.5"
}

variable "vm_size" {
  description = "VM size for the nodes"
  type        = string
  default     = "Standard_D2s_v3" # Smaller VM size, good balance of CPU/memory
}

variable "vnet_name" {
  description = "Name of the existing VNet"
  type        = string
}

variable "vnet_resource_group_name" {
  description = "Resource group name of the existing VNet"
  type        = string
}

variable "services_subnet_id" {
  description = "ID of the subnet for AKS"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key for the nodes. "
  type        = string
  default     = null
}

variable "system_vm_size" {
  description = "VM size for the system nodes"
  type        = string
  default     = "Standard_D2ps_v6"
}

