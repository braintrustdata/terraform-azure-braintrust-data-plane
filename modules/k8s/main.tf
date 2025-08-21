locals {
  cluster_name = "${var.deployment_name}-${var.cluster_name}"
}

data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

data "azurerm_virtual_network" "main" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_user_assigned_identity" "aks_identity" {
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  name                = "${local.cluster_name}-identity"
}

resource "azurerm_role_assignment" "aks_identity" {
  for_each = toset([
    "Contributor",
    "Azure Kubernetes Service RBAC Cluster Admin",
    "Key Vault Secrets User"
  ])
  scope                = data.azurerm_resource_group.main.id
  role_definition_name = each.value
  principal_id         = azurerm_user_assigned_identity.aks_identity.principal_id
  principal_type       = "ServicePrincipal"
}

resource "azurerm_kubernetes_cluster" "aks" {
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  name                = local.cluster_name
  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.aks_identity.id,
    ]
  }

  sku_tier = "Standard"
  default_node_pool {
    name                 = "nodepool"
    vm_size              = var.system_pool_vm_size
    node_count           = 3
    min_count            = 3
    max_count            = 6
    auto_scaling_enabled = true
    vnet_subnet_id       = var.services_subnet_id
    upgrade_settings {
      drain_timeout_in_minutes      = 0
      max_surge                     = "10%"
      node_soak_duration_in_minutes = 0
    }
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  oidc_issuer_enabled = true

  dns_prefix = local.cluster_name
  # private_cluster_enabled             = false
  # private_cluster_public_fqdn_enabled = false
  # private_dns_zone_id                 = azurerm_private_dns_zone.aks.id
  workload_identity_enabled = true

  storage_profile {
    blob_driver_enabled         = true
    disk_driver_enabled         = false
    file_driver_enabled         = false
    snapshot_controller_enabled = false
  }

  monitor_metrics {
    annotations_allowed = null
    labels_allowed      = "nodes=[*]"
  }

  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count
    ]
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "user" {
  kubernetes_cluster_id       = azurerm_kubernetes_cluster.aks.id
  auto_scaling_enabled        = true
  name                        = "user"
  mode                        = "User"
  min_count                   = 2
  max_count                   = var.user_pool_max_count
  node_count                  = 2
  vm_size                     = var.user_pool_vm_size
  vnet_subnet_id              = var.services_subnet_id
  temporary_name_for_rotation = "userrotate"
}


#----------------------------------------------------------------------------------------------
# Federated identity credentials
#----------------------------------------------------------------------------------------------
# Format: `system:serviceaccount:<kubernetes-namespace>:<kubernetes-service-account-name>`
# These are hard coded to match the default service account name in the helm chart.
# What does this do in English:
# When a Kubernetes service account with this specific identity
# tries to authenticate, trust it and grant it access to the Azure resources associated with this
# user-assigned managed identity.

resource "azurerm_federated_identity_credential" "braintrust_api" {
  name                = "${local.cluster_name}-braintrust-api"
  resource_group_name = data.azurerm_resource_group.main.name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.aks.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.aks_identity.id
  subject             = "system:serviceaccount:braintrust:braintrust-api"
}

resource "azurerm_federated_identity_credential" "brainstore" {
  name                = "${local.cluster_name}-brainstore"
  resource_group_name = data.azurerm_resource_group.main.name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.aks.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.aks_identity.id
  subject             = "system:serviceaccount:braintrust:brainstore"
}

# Uncommenting these plus the private_* ones in the k8s cluster above makes the cluster private.
# Meaning there is no way to run kubectl from outside of the VNet (e.g. your laptop).
# If there is demand we can parameterize this.
# resource "azurerm_private_dns_zone" "aks" {
#   resource_group_name = var.resource_group_name
#   name                = "privatelink.${data.azurerm_resource_group.main.location}.azmk8s.io"
# }

# resource "azurerm_private_dns_zone_virtual_network_link" "aksdns_in_aksvnet" {
#   name                  = "aksvnet-akszone"
#   resource_group_name   = var.resource_group_name
#   private_dns_zone_name = azurerm_private_dns_zone.aks.name
#   virtual_network_id    = data.azurerm_virtual_network.main.id
#   registration_enabled  = false
# }
