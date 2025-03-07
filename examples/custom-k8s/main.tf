locals {
  deployment_name = "braintrust"
  location        = "eastus"
}

resource "azurerm_resource_group" "main" {
  name     = local.deployment_name
  location = local.location
}

module "kms" {
  source = "../../modules/kms"
  # source = "github.com/braintrustdata/terraform-azure-braintrust-data-plane//modules/kms"

  deployment_name            = local.deployment_name
  resource_group_name        = azurerm_resource_group.main.name
  location                   = local.location
  virtual_network_id         = module.vnet.vnet_id
  private_endpoint_subnet_id = module.vnet.private_endpoint_subnet_id
}

module "database" {
  source = "../../modules/database"
  # source = "github.com/braintrustdata/terraform-azure-braintrust-data-plane//modules/database"

  deployment_name     = local.deployment_name
  resource_group_name = azurerm_resource_group.main.name
  location            = local.location

  postgres_sku_name     = null
  postgres_storage_mb   = null
  postgres_version      = null
  postgres_storage_tier = null

  vnet_id                    = module.vnet.vnet_id
  private_endpoint_subnet_id = module.vnet.private_endpoint_subnet_id
  key_vault_id               = module.kms.key_vault_id
}

module "redis" {
  source = "../../modules/redis"
  # source = "github.com/braintrustdata/terraform-azure-braintrust-data-plane//modules/redis"

  deployment_name     = local.deployment_name
  resource_group_name = azurerm_resource_group.main.name
  location            = local.location

  redis_sku_name = null
  redis_family   = null
  redis_capacity = null
  redis_version  = null

  virtual_network_id         = module.vnet.vnet_id
  private_endpoint_subnet_id = module.vnet.private_endpoint_subnet_id
  key_vault_id               = module.kms.key_vault_id
}

module "vnet" {
  source = "../../modules/vnet"
  # source = "github.com/braintrustdata/terraform-azure-braintrust-data-plane//modules/vnet"

  deployment_name     = local.deployment_name
  resource_group_name = azurerm_resource_group.main.name
  location            = local.location

  vnet_name               = "main"
  vnet_address_space_cidr = "10.190.0.0/16"
}

resource "azurerm_kubernetes_cluster" "main" {
  name                = "${local.deployment_name}-aks"
  location            = local.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = "${local.deployment_name}-k8s"
  kubernetes_version  = "1.28.3"

  default_node_pool {
    name                = "default"
    node_count          = 2
    vm_size             = "Standard_D2s_v3"
    vnet_subnet_id      = module.vnet.services_subnet_id
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


