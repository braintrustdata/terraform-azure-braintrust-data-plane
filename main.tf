locals {
  key_vault_id = var.key_vault_id != null ? var.key_vault_id : module.kms[0].key_vault_id
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
  virtual_network_id         = var.existing_vnet.id == "" ? module.main_vnet[0].vnet_id : var.existing_vnet.id
  private_endpoint_subnet_id = var.existing_vnet.id == "" ? module.main_vnet[0].private_endpoint_subnet_id : var.existing_vnet.private_endpoint_subnet_id
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

  vnet_id                    = var.existing_vnet.id == "" ? module.main_vnet[0].vnet_id : var.existing_vnet.id
  private_endpoint_subnet_id = var.existing_vnet.id == "" ? module.main_vnet[0].private_endpoint_subnet_id : var.existing_vnet.private_endpoint_subnet_id
  key_vault_id               = local.key_vault_id
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

  virtual_network_id         = var.existing_vnet.id == "" ? module.main_vnet[0].vnet_id : var.existing_vnet.id
  private_endpoint_subnet_id = var.existing_vnet.id == "" ? module.main_vnet[0].private_endpoint_subnet_id : var.existing_vnet.private_endpoint_subnet_id
  key_vault_id               = local.key_vault_id
}
