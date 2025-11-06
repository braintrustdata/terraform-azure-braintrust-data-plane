locals {
  key_vault_id                   = var.key_vault_id != null ? var.key_vault_id : module.kms[0].key_vault_id
  vnet_id                        = var.existing_vnet.id == "" ? module.main_vnet[0].vnet_id : var.existing_vnet.id
  services_subnet_id             = var.existing_vnet.id == "" ? module.main_vnet[0].services_subnet_id : var.existing_vnet.services_subnet_id
  private_endpoint_subnet_id     = var.existing_vnet.id == "" ? module.main_vnet[0].private_endpoint_subnet_id : var.existing_vnet.private_endpoint_subnet_id
  private_link_service_subnet_id = var.existing_vnet.id == "" ? module.main_vnet[0].private_link_service_subnet_id : null
}

resource "azurerm_resource_group" "main" {
  name     = var.deployment_name
  location = var.location
}

module "kms" {
  source = "./modules/kms"
  count  = var.key_vault_id == null ? 1 : 0

  deployment_name            = var.deployment_name
  resource_group_name        = azurerm_resource_group.main.name
  location                   = var.location
  virtual_network_id         = local.vnet_id
  private_endpoint_subnet_id = local.private_endpoint_subnet_id
}

module "main_vnet" {
  source = "./modules/vnet"
  count  = var.existing_vnet.id == "" ? 1 : 0

  deployment_name     = var.deployment_name
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location

  vnet_name                    = "main"
  vnet_address_space_cidr      = var.vnet_address_space_cidr
  services_subnet_cidr         = var.services_subnet_cidr
  private_endpoint_subnet_cidr = var.private_endpoint_subnet_cidr
  enable_front_door            = var.enable_front_door
}

module "k8s" {
  source = "./modules/k8s"
  count  = var.create_aks_cluster ? 1 : 0

  deployment_name     = var.deployment_name
  resource_group_name = azurerm_resource_group.main.name
  resource_group_id   = azurerm_resource_group.main.id
  services_subnet_id  = local.services_subnet_id
  user_pool_vm_size   = var.aks_user_pool_vm_size
  user_pool_max_count = var.aks_user_pool_max_count
  system_pool_vm_size = var.aks_system_pool_vm_size
  location            = var.location
}

module "database" {
  source = "./modules/database"

  deployment_name     = var.deployment_name
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location

  postgres_sku_name     = var.postgres_sku_name
  postgres_storage_mb   = var.postgres_storage_mb
  postgres_version      = var.postgres_version
  postgres_storage_tier = var.postgres_storage_tier

  vnet_id                    = local.vnet_id
  private_endpoint_subnet_id = local.private_endpoint_subnet_id
  key_vault_id               = local.key_vault_id

  existing_postgres_private_dns_zone_id = var.existing_postgres_private_dns_zone_id
}

module "redis" {
  source = "./modules/redis"

  deployment_name     = var.deployment_name
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location

  redis_sku_name = var.redis_sku_name
  redis_family   = var.redis_family
  redis_capacity = var.redis_capacity
  redis_version  = var.redis_version

  virtual_network_id         = local.vnet_id
  private_endpoint_subnet_id = local.private_endpoint_subnet_id
  key_vault_id               = local.key_vault_id

  existing_redis_private_dns_zone_id = var.existing_redis_private_dns_zone_id
}

module "storage" {
  source = "./modules/storage"

  resource_group_name        = azurerm_resource_group.main.name
  deployment_name            = var.deployment_name
  location                   = var.location
  vnet_id                    = local.vnet_id
  private_endpoint_subnet_id = local.private_endpoint_subnet_id
  key_vault_id               = local.key_vault_id
  create_storage_container   = var.create_storage_container

  existing_blob_private_dns_zone_id = var.existing_blob_private_dns_zone_id
}

module "front_door" {
  source = "./modules/front_door"
  count  = var.enable_front_door ? 1 : 0

  resource_group_name                 = azurerm_resource_group.main.name
  deployment_name                     = var.deployment_name
  location                            = var.location
  api_backend_address                 = var.front_door_api_backend_address
  api_backend_port                    = var.front_door_api_backend_port
  load_balancer_frontend_ip_config_id = var.front_door_load_balancer_frontend_ip_config_id
  private_link_service_subnet_id      = local.private_link_service_subnet_id
}

# Used for encrypting function env secrets. Function environment secrets can be specified
# per org, project, or function and are exposed to functions as environment variables.
resource "azurerm_key_vault_secret" "function_secret" {
  name         = "function-secret-key"
  value        = random_password.function_secret.result
  key_vault_id = local.key_vault_id
}

resource "random_password" "function_secret" {
  length  = 32
  special = true
}

resource "azurerm_key_vault_secret" "brainstore_license_key" {
  name         = "brainstore-license-key"
  value        = var.brainstore_license_key
  key_vault_id = local.key_vault_id
  # This is required because some customers can't support including secrets in CI
  # This lets them use "" and then later manually enter the secret directly into the key vault
  # If this ever needs to change it can be done by tainting the resource
  lifecycle {
    ignore_changes = [
      value
    ]
  }
}
