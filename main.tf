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
  virtual_network_id         = module.main_vnet.vnet_id
  private_endpoint_subnet_id = module.main_vnet.private_endpoint_subnet_id
}

module "main_vnet" {
  source = "./modules/vnet"

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

  vnet_id                    = module.main_vnet.vnet_id
  private_endpoint_subnet_id = module.main_vnet.private_endpoint_subnet_id
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

  virtual_network_id         = module.main_vnet.vnet_id
  private_endpoint_subnet_id = module.main_vnet.private_endpoint_subnet_id
  key_vault_id               = local.key_vault_id
}

module "storage" {
  source = "./modules/storage"

  resource_group_name        = azurerm_resource_group.main.name
  deployment_name            = var.deployment_name
  location                   = var.location
  vnet_id                    = module.main_vnet.vnet_id
  private_endpoint_subnet_id = module.main_vnet.private_endpoint_subnet_id
  key_vault_id               = local.key_vault_id
}

resource "kubernetes_namespace" "main" {
  metadata {
    name = "${var.deployment_name}-data-plane"
  }
}

resource "kubernetes_config_map" "main" {
  metadata {
    namespace = kubernetes_namespace.main.metadata[0].name
    name      = "braintrust-data-plane-config"
  }

  data = {
    "REDIS_HOST"                  = module.redis.redis_hostname
    "REDIS_PORT"                  = module.redis.redis_ssl_port
    "REDIS_PASSWORD_SECRET_ID"    = module.redis.redis_password_secret_id
    "POSTGRES_HOST"               = module.database.postgres_database_fqdn
    "POSTGRES_PORT"               = "5432"
    "POSTGRES_USER"               = module.database.postgres_database_username
    "POSTGRES_DB"                 = module.database.postgres_database_name
    "POSTGRES_PASSWORD_SECRET_ID" = module.database.postgres_password_secret_id
    "KEY_VAULT_NAME"              = module.kms.key_vault_name
    "BRAINSTORE_URL"              = "http://brainstore.${kubernetes_namespace.main.metadata[0].name}.svc.cluster.local:80"
  }
}

ephemeral "azurerm_key_vault_secret" "redis_password" {
  name         = module.redis.redis_password_secret_name
  key_vault_id = local.key_vault_id
}

ephemeral "azurerm_key_vault_secret" "postgres_password" {
  name         = module.database.postgres_password_secret_name
  key_vault_id = local.key_vault_id
}

resource "kubernetes_secret" "credentials" {
  metadata {
    namespace = kubernetes_namespace.main.metadata[0].name
    name      = "braintrust-data-plane-secrets"
  }

  data = {
    "REDIS_PASSWORD"    = ephemeral.azurerm_key_vault_secret.redis_password.value
    "POSTGRES_PASSWORD" = ephemeral.azurerm_key_vault_secret.postgres_password.value
    "PG_URL"            = "postgres://${module.database.postgres_database_username}:${ephemeral.azurerm_key_vault_secret.postgres_password.value}@${module.database.postgres_database_fqdn}:5432/${module.database.postgres_database_name}"
    "REDIS_URL"         = "rediss://:${ephemeral.azurerm_key_vault_secret.redis_password.value}@${module.redis.redis_hostname}:${module.redis.redis_ssl_port}"
  }

  type = "Opaque"
}
