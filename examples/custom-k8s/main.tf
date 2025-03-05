locals {
  deployment_name = "braintrust"
  location        = "eastus"

  vnet_address_space_cidr = "10.190.0.0/16"
  # Let these all be auto-calculated by the vnet module
  database_subnet_cidr = null
  services_subnet_cidr = null
  gateway_subnet_cidr  = null
  redis_subnet_cidr    = null

  # Use defaults from the postgres module
  postgres_sku_name     = null
  postgres_storage_mb   = null
  postgres_version      = null
  postgres_storage_tier = null

  # Use defaults from the redis module
  redis_sku_name = null
  redis_family   = null
  redis_capacity = null
  redis_version  = null
}


resource "azurerm_resource_group" "main" {
  name     = local.deployment_name
  location = local.location
}

module "kms" {
  source = "../../modules/kms"

  deployment_name            = local.deployment_name
  resource_group_name        = azurerm_resource_group.main.name
  location                   = local.location
  virtual_network_id         = module.main_vnet.vnet_id
  private_endpoint_subnet_id = module.main_vnet.private_endpoint_subnet_id
}

module "main_vnet" {
  source = "../../modules/vnet"

  deployment_name     = local.deployment_name
  resource_group_name = azurerm_resource_group.main.name
  location            = local.location

  vnet_name               = "main"
  vnet_address_space_cidr = local.vnet_address_space_cidr
  database_subnet_cidr    = local.database_subnet_cidr
  services_subnet_cidr    = local.services_subnet_cidr
  gateway_subnet_cidr     = local.gateway_subnet_cidr
  redis_subnet_cidr       = local.redis_subnet_cidr
}

resource "azurerm_kubernetes_cluster" "main" {
  name                = "${local.deployment_name}-aks"
  location            = local.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = "${local.deployment_name}-k8s"
  kubernetes_version  = "1.28.3" # Specify your desired Kubernetes version

  default_node_pool {
    name                = "default"
    node_count          = 2
    vm_size             = "Standard_D2s_v3"
    vnet_subnet_id      = module.main_vnet.services_subnet_id
    enable_auto_scaling = true
    min_count           = 1
    max_count           = 3
    os_disk_size_gb     = 30
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin     = "azure"
    load_balancer_sku  = "standard"
    network_data_plane = "cilium"
    network_policy     = "cilium"
  }

  role_based_access_control_enabled = true
}

module "database" {
  source = "../../modules/database"

  deployment_name     = local.deployment_name
  resource_group_name = azurerm_resource_group.main.name
  location            = local.location

  postgres_sku_name     = local.postgres_sku_name
  postgres_storage_mb   = local.postgres_storage_mb
  postgres_version      = local.postgres_version
  postgres_storage_tier = local.postgres_storage_tier

  vnet_id                    = module.main_vnet.vnet_id
  subnet_id                  = module.main_vnet.database_subnet_id
  private_endpoint_subnet_id = module.main_vnet.private_endpoint_subnet_id
  key_vault_id               = module.kms.key_vault_id
}

module "redis" {
  source = "../../modules/redis"

  deployment_name     = local.deployment_name
  resource_group_name = azurerm_resource_group.main.name
  location            = local.location

  redis_sku_name = local.redis_sku_name
  redis_family   = local.redis_family
  redis_capacity = local.redis_capacity
  redis_version  = local.redis_version

  virtual_network_id         = module.main_vnet.vnet_id
  private_endpoint_subnet_id = module.main_vnet.private_endpoint_subnet_id
  key_vault_id               = module.kms.key_vault_id
}
