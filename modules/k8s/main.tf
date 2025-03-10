resource "azurerm_log_analytics_workspace" "aks" {
  name                = "${var.cluster_name}-log-analytics"
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_user_assigned_identity" "aks_identity" {
  resource_group_name = azurerm_resource_group.aks.name
  location            = azurerm_resource_group.aks.location
  name                = "${var.cluster_name}-identity"
}

resource "azurerm_role_assignment" "aks_network" {
  scope                = data.azurerm_subnet.existing.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_identity.principal_id
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                      = var.cluster_name
  location                  = azurerm_resource_group.aks.location
  resource_group_name       = azurerm_resource_group.aks.name
  dns_prefix                = var.cluster_name
  kubernetes_version        = var.kubernetes_version
  private_cluster_enabled   = false
  sku_tier                  = "Standard"
  automatic_channel_upgrade = "stable"

  default_node_pool {
    name                   = "system"
    node_count             = 3
    vm_size                = var.system_vm_size
    enable_host_encryption = true

    temporary_name_for_rotation = "system-rotating"
    vnet_subnet_id              = var.services_subnet_id
    orchestrator_version        = var.kubernetes_version
    os_sku                      = "Ubuntu"
    os_disk_size_gb             = 50
    os_disk_type                = "Managed"
    type                        = "VirtualMachineScaleSets"
    # enable_auto_scaling         = true
    # min_count                   = 2
    # max_count                   = 3
    # max_pods                    = 30
  }

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.aks_identity.id
    ]
  }

  # Network profile
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

  linux_profile {
    admin_username = "azure"
    ssh_key {
      key_data = var.ssh_public_key
    }
  }

  azure_active_directory_role_based_access_control {
    azure_rbac_enabled = true
  }

  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count
    ]
  }
}

# Allow SSH login via AAD (Entra ID). Assign a user/group the "Virtual Machine Administrator Login" role and then use `az ssh vm`
resource "azurerm_virtual_machine_scale_set_extension" "aad_ssh" {
  name                         = "AADSSHLoginForLinux"
  virtual_machine_scale_set_id = azurerm_kubernetes_cluster.aks.default_node_pool[0].id
  publisher                    = "Microsoft.Azure.ActiveDirectory.LinuxSSH"
  type                         = "AADSSHLoginForLinux"
  type_handler_version         = "1.0"
}

resource "azurerm_kubernetes_cluster_node_pool" "services" {
  name                  = "services"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = var.vm_size
  vnet_subnet_id        = var.services_subnet_id
  enable_auto_scaling   = true
  min_count             = 2
  max_count             = 3
  max_pods              = 30
  zones                 = ["1", "2"]
}
