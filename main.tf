module "kms" {
  source = "./modules/kms"
  count  = var.key_vault_id == null ? 1 : 0

  deployment_name     = var.deployment_name
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
}

locals {
  key_vault_id = var.key_vault_id != null ? var.key_vault_id : module.kms[0].key_vault_id
}

resource "azurerm_resource_group" "main" {
  name     = "rg-${var.deployment_name}"
  location = var.location

  tags = {
    deployment = var.deployment_name
  }
}

module "main_vnet" {
  source = "./modules/vnet"

  deployment_name     = var.deployment_name
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  vnet_name           = "main"
  vnet_address_space  = var.vnet_address_space

  public_subnet_cidr    = cidrsubnet(var.vnet_address_space, 8, 0)
  private_subnet_1_cidr = cidrsubnet(var.vnet_address_space, 8, 1)
  private_subnet_2_cidr = cidrsubnet(var.vnet_address_space, 8, 2)
  private_subnet_3_cidr = cidrsubnet(var.vnet_address_space, 8, 3)
}

module "quarantine_vnet" {
  source = "./modules/vnet"
  count  = var.enable_quarantine_vnet ? 1 : 0

  deployment_name     = var.deployment_name
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  vnet_name           = "quarantine"
  vnet_address_space  = var.quarantine_vnet_address_space

  public_subnet_cidr    = cidrsubnet(var.quarantine_vnet_address_space, 8, 0)
  private_subnet_1_cidr = cidrsubnet(var.quarantine_vnet_address_space, 8, 1)
  private_subnet_2_cidr = cidrsubnet(var.quarantine_vnet_address_space, 8, 2)
  private_subnet_3_cidr = cidrsubnet(var.quarantine_vnet_address_space, 8, 3)
}

module "database" {
  source = "./modules/database"

  deployment_name     = var.deployment_name
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  postgres_sku_name   = var.postgres_sku_name
  postgres_storage_mb = var.postgres_storage_mb
  postgres_version    = var.postgres_version

  vnet_id = module.main_vnet.vnet_id
  subnet_ids = [
    module.main_vnet.private_subnet_1_id,
    module.main_vnet.private_subnet_2_id,
    module.main_vnet.private_subnet_3_id
  ]

  key_vault_id = local.key_vault_id
}

module "redis" {
  source = "./modules/redis"

  deployment_name     = var.deployment_name
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  subnet_id           = module.main_vnet.private_subnet_1_id
  redis_sku_name      = var.redis_sku_name
  redis_family        = var.redis_family
  redis_capacity      = var.redis_capacity
  redis_version       = var.redis_version
}

module "services" {
  source = "./modules/services"

  deployment_name     = var.deployment_name
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location

  # Data stores
  postgres_username = module.database.postgres_database_username
  postgres_password = module.database.postgres_database_password
  postgres_host     = module.database.postgres_database_fqdn
  postgres_port     = module.database.postgres_database_port
  redis_host        = module.redis.redis_hostname
  redis_port        = module.redis.redis_port
  redis_password    = module.redis.redis_primary_key

  # Service configuration
  braintrust_org_name                = var.braintrust_org_name
  api_handler_scale_out_capacity     = var.api_handler_scale_out_capacity
  whitelisted_origins                = var.whitelisted_origins
  outbound_rate_limit_window_minutes = var.outbound_rate_limit_window_minutes
  outbound_rate_limit_max_requests   = var.outbound_rate_limit_max_requests
  custom_domain                      = var.custom_domain
  custom_certificate_id              = var.custom_certificate_id

  # Networking
  vnet_id = module.main_vnet.vnet_id
  subnet_ids = [
    module.main_vnet.private_subnet_1_id,
    module.main_vnet.private_subnet_2_id,
    module.main_vnet.private_subnet_3_id
  ]

  # Quarantine VNet
  use_quarantine_vnet = var.enable_quarantine_vnet
  quarantine_vnet_id  = var.enable_quarantine_vnet ? module.quarantine_vnet[0].vnet_id : null
  quarantine_vnet_subnet_ids = var.enable_quarantine_vnet ? [
    module.quarantine_vnet[0].private_subnet_1_id,
    module.quarantine_vnet[0].private_subnet_2_id,
    module.quarantine_vnet[0].private_subnet_3_id
  ] : []

  key_vault_id = local.key_vault_id
}
