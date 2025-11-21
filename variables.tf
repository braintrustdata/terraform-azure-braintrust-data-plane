variable "braintrust_org_name" {
  type        = string
  description = "The name of your organization in Braintrust (e.g. acme.com)"
}

variable "deployment_name" {
  type        = string
  default     = "braintrust"
  description = "Name of this Braintrust deployment. Will be included in tags and prefixes in resources names. Lowercase letter, numbers, and hyphens only. If you want multiple deployments in your same Azure subscription, use a unique name for each deployment."
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.deployment_name))
    error_message = "The deployment_name must contain only lowercase letters, numbers and hyphens in order to be compatible with Azure resource naming restrictions."
  }
  validation {
    condition     = length(var.deployment_name) <= 18
    error_message = "The deployment_name must be 18 characters or less."
  }
}

variable "location" {
  type        = string
  description = "Azure region to deploy resources to"
}

variable "key_vault_id" {
  description = "Existing Key Vault ID to use for encrypting resources. If not provided, a new Key Vault will be created. DO NOT change this after deployment."
  type        = string
  default     = null
}

variable "brainstore_license_key" {
  type        = string
  description = "The license key for the Brainstore instance. You can find this in the Braintrust UI under Settings > Data Plane > Brainstore License Key."
}

## NETWORKING

variable "existing_vnet" {
  type = object({
    id                                         = string
    name                                       = string
    services_subnet_id                         = string
    private_endpoint_subnet_id                 = string
    private_endpoint_network_security_group_id = string
    address_space                              = string
  })
  default = {
    id                                         = ""
    name                                       = ""
    services_subnet_id                         = ""
    private_endpoint_subnet_id                 = ""
    private_endpoint_network_security_group_id = ""
    address_space                              = ""
  }
}


variable "vnet_address_space_cidr" {
  type        = string
  description = "Address space for the VNet"
  default     = "10.175.0.0/20" # 4096 IP addresses
}

variable "services_subnet_cidr" {
  description = "CIDR block for the services subnet. Leave blank to auto-calculate one."
  type        = string
  default     = null
}

variable "private_endpoint_subnet_cidr" {
  description = "CIDR block for the private endpoint subnet. Leave blank to auto-calculate one."
  type        = string
  default     = null
}


variable "existing_postgres_private_dns_zone_id" {
  description = "Advanced: Use an existing private dns zone id for postgres private endpoint. Only needed if you want to deploy two data planes into the same VNet."
  type        = string
  default     = ""
}

variable "existing_blob_private_dns_zone_id" {
  description = "Advanced: Use an existing private dns zone id for blob storage private endpoint. Only needed if you want to deploy two data planes into the same VNet."
  type        = string
  default     = ""
}

variable "existing_redis_private_dns_zone_id" {
  description = "Advanced: Use an existing private dns zone id for redis private endpoint. Only needed if you want to deploy two data planes into the same VNet."
  type        = string
  default     = ""
}


## AKS
variable "create_aks_cluster" {
  description = "Create an AKS cluster"
  type        = bool
  ## This should be made default on in a future release
  default = false
}

variable "aks_system_pool_vm_size" {
  description = "VM size for the system nodes"
  type        = string
  default     = "Standard_D2as_v6"
}

variable "aks_brainstore_pool_vm_size" {
  description = "VM size for the brainstore node pool. Must be a SKU with a temporary local storage SSD."
  type        = string
  default     = "Standard_D32ds_v6"
}

variable "aks_brainstore_pool_max_count" {
  description = "Maximum number of nodes in the brainstore pool"
  type        = number
  default     = 10
}

variable "aks_services_pool_vm_size" {
  description = "VM size for the services node pool. Must be a SKU with a temporary local storage SSD."
  type        = string
  default     = "Standard_D16s_v6"
}

variable "aks_services_pool_max_count" {
  description = "Maximum number of nodes in the services pool"
  type        = number
  default     = 10
}


## Database
variable "postgres_sku_name" {
  description = "SKU name for the Azure Database for PostgreSQL instance."
  type        = string
  default     = "MO_Standard_E2ds_v5"
}

variable "postgres_storage_mb" {
  description = "Storage size (in MB) for the Azure Database for PostgreSQL instance."
  type        = number
  default     = 131072
}

variable "postgres_storage_tier" {
  description = "Storage tier for the Azure Database for PostgreSQL instance."
  type        = string
  default     = "P20"
}

variable "postgres_version" {
  description = "PostgreSQL engine version for the Azure Database for PostgreSQL instance."
  type        = string
  default     = "15"
}

## Redis
variable "redis_sku_name" {
  description = "SKU name for the Azure Cache for Redis instance"
  type        = string
  default     = "Standard"
}

variable "redis_family" {
  description = "Family for the Azure Cache for Redis instance"
  type        = string
  default     = "C"
}

variable "redis_capacity" {
  description = "Capacity for the Azure Cache for Redis instance"
  type        = number
  default     = 1
}

variable "redis_version" {
  description = "Redis engine version"
  type        = string
  default     = "6"
}

## Storage
variable "create_storage_container" {
  description = "Create containers for the blobstorage. Defaults to true. Disable this if CI CD cannot reach the storage APIs."
  type        = bool
  default     = true
}

## Front Door
variable "enable_front_door" {
  description = "Enable Azure Front Door with Private Link connectivity to the API workload. This must be done after the AKS cluster is created and the Helm chartis deployed."
  type        = bool
  default     = false
}

variable "front_door_api_backend_address" {
  description = "IP address or hostname of the API backend workload (required if enable_front_door is true). This should be the IP address of the internal load balancer generated by AKS."
  type        = string
  default     = null
}

variable "front_door_api_backend_port" {
  description = "Port for the API backend workload"
  type        = number
  default     = 8000
}

variable "front_door_load_balancer_frontend_ip_config_id" {
  description = "Resource ID of the AKS internal load balancer frontend IP configuration (required if enable_front_door is true)."
  type        = string
  default     = null
}
