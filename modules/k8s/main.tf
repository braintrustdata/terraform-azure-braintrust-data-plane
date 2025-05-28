resource "azurerm_federated_identity_credential" "secrets_store_csi" {
  name                = "mdeeks-k8s-secrets-store-csi"
  resource_group_name = var.resource_group_name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.aks.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.secrets_csi_identity.id
  subject             = "system:serviceaccount:braintrust:braintrust-api"
}

resource "azurerm_log_analytics_workspace" "aks" {
  name                = "${var.cluster_name}-log-analytics"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_user_assigned_identity" "secrets_csi_identity" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = "${var.cluster_name}-secrets-store-csi"
}

resource "azurerm_role_assignment" "secrets_csi_identity_role" {
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.secrets_csi_identity.principal_id
}

resource "azurerm_role_assignment" "secrets_csi_vmss_identity" {
  scope                = azurerm_kubernetes_cluster.aks.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = azurerm_user_assigned_identity.secrets_csi_identity.principal_id
}

resource "azurerm_role_assignment" "secrets_csi_services_vmss_identity" {
  scope                = azurerm_kubernetes_cluster_node_pool.services.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = azurerm_user_assigned_identity.secrets_csi_identity.principal_id
}

resource "azurerm_user_assigned_identity" "aks_identity" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = "${var.cluster_name}-identity"
}

resource "azurerm_role_assignment" "aks_network" {
  scope                = var.services_subnet_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_identity.principal_id
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                      = var.cluster_name
  location                  = var.location
  resource_group_name       = var.resource_group_name
  dns_prefix                = var.cluster_name
  kubernetes_version        = var.kubernetes_version
  private_cluster_enabled   = false
  sku_tier                  = "Standard"
  automatic_upgrade_channel = "stable"

  default_node_pool {
    name                    = "system"
    node_count              = 3
    vm_size                 = var.system_vm_size
    host_encryption_enabled = true

    # temporary_name_for_rotation = "system-rotating"
    vnet_subnet_id       = var.services_subnet_id
    orchestrator_version = var.kubernetes_version
    os_sku               = "Ubuntu"
    os_disk_size_gb      = 50
    os_disk_type         = "Managed"
    type                 = "VirtualMachineScaleSets"
    # enable_auto_scaling         = true
    # min_count                   = 2
    # max_count                   = 3
    # max_pods                    = 30
    upgrade_settings {
      drain_timeout_in_minutes      = 0
      max_surge                     = "10%"
      node_soak_duration_in_minutes = 0
    }
  }

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.aks_identity.id
    ]
  }
  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }


  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
    outbound_type     = "loadBalancer"
    network_policy    = "calico"
  }

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.aks.id
  }

  azure_policy_enabled = true

  # linux_profile {
  #   admin_username = "azure"
  #   ssh_key {
  #     key_data = var.ssh_public_key
  #   }
  # }


  azure_active_directory_role_based_access_control {
    tenant_id          = data.azurerm_client_config.current.tenant_id
    azure_rbac_enabled = true
  }

  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count
    ]
  }
}

data "azurerm_client_config" "current" {}

# Allow SSH login via AAD (Entra ID). Assign a user/group the "Virtual Machine Administrator Login" role and then use `az ssh vm`
# resource "azurerm_virtual_machine_scale_set_extension" "aad_ssh" {
#   name                         = "AADSSHLoginForLinux"
#   virtual_machine_scale_set_id = azurerm_kubernetes_cluster.aks.default_node_pool[0].id
#   publisher                    = "Microsoft.Azure.ActiveDirectory.LinuxSSH"
#   type                         = "AADSSHLoginForLinux"
#   type_handler_version         = "1.0"
# }

resource "azurerm_kubernetes_cluster_node_pool" "services" {
  name                        = "services"
  kubernetes_cluster_id       = azurerm_kubernetes_cluster.aks.id
  vm_size                     = var.vm_size
  vnet_subnet_id              = var.services_subnet_id
  auto_scaling_enabled        = true
  min_count                   = 2
  max_count                   = 3
  max_pods                    = 30
  zones                       = ["1", "2"]
  temporary_name_for_rotation = "rotating"
}

