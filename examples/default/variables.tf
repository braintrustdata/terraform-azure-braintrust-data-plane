variable "azure_subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "braintrust_org_name" {
  description = "The name of your organization in Braintrust (e.g. acme.com)"
  type        = string
}

variable "brainstore_license_key" {
  description = "The license key for Brainstore. Find this in Braintrust UI under Settings > Data Plane > Brainstore License Key."
  type        = string
  sensitive   = true
}

variable "deployment_name" {
  description = "Name of this deployment. Used as prefix for all resources. Lowercase letters, numbers, and hyphens only."
  type        = string
  default     = "braintrust"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.deployment_name))
    error_message = "deployment_name must contain only lowercase letters, numbers, and hyphens."
  }

  validation {
    condition     = length(var.deployment_name) <= 18
    error_message = "deployment_name must be 18 characters or less."
  }
}

variable "location" {
  description = "Azure region to deploy resources"
  type        = string
  default     = "eastus"
}

variable "enable_front_door" {
  description = "Enable Azure Front Door with Private Link connectivity"
  type        = bool
  default     = false
}

variable "front_door_api_backend_address" {
  description = "IP address of the AKS internal load balancer for the API service (required for Front Door)"
  type        = string
  default     = null
}

variable "front_door_load_balancer_frontend_ip_config_id" {
  description = "Resource ID of the AKS internal load balancer frontend IP configuration (required for Front Door)"
  type        = string
  default     = null
}
