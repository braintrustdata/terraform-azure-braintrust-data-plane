resource "azurerm_virtual_network" "main" {
  name                = "${var.deployment_name}-${var.vnet_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.vnet_address_space_cidr]
}

resource "azurerm_subnet" "database" {
  name                 = "${var.deployment_name}-database"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.database_subnet_cidr]
  service_endpoints    = ["Microsoft.Storage"]

  delegation {
    name = "fs"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_subnet" "gateway-lb" {
  name                 = "${var.deployment_name}-gateway-lb"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.gateway_subnet_cidr]
}

resource "azurerm_subnet" "services" {
  name                 = "${var.deployment_name}-services"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.services_subnet_cidr]
}

resource "azurerm_subnet" "redis" {
  name                 = "${var.deployment_name}-redis"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.redis_subnet_cidr]
}

