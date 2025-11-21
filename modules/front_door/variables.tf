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

variable "api_backend_address" {
  type        = string
  description = "IP address or hostname of the API backend workload (used as origin hostname)"
}

variable "api_backend_port" {
  type        = number
  description = "Port for the API backend workload"
  default     = 8000
}

variable "load_balancer_frontend_ip_config_id" {
  type        = string
  description = "Resource ID of the AKS internal load balancer frontend IP configuration"
}

variable "private_link_service_subnet_id" {
  type        = string
  description = "Subnet ID for the Private Link Service NAT IP configuration"
}
