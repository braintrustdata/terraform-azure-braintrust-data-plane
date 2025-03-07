resource "azurerm_virtual_network" "main" {
  name                = "${var.deployment_name}-${var.vnet_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [local.vnet_address_space_cidr]
}

resource "azurerm_subnet" "database" {
  name                 = "${var.deployment_name}-database"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [local.database_subnet_cidr]
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

resource "azurerm_subnet" "services" {
  name                 = "${var.deployment_name}-services"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [local.services_subnet_cidr]
}


resource "azurerm_network_security_rule" "services_to_database" {
  name                        = "services-to-database"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "5432"
  source_address_prefix       = local.services_subnet_cidr
  destination_address_prefix  = local.database_subnet_cidr
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.database.name
}

resource "azurerm_subnet_network_security_group_association" "database" {
  subnet_id                 = azurerm_subnet.database.id
  network_security_group_id = azurerm_network_security_group.database.id
}

resource "azurerm_network_security_group" "redis" {
  name                = "${var.deployment_name}-redis-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet_network_security_group_association" "redis" {
  subnet_id                 = azurerm_subnet.redis.id
  network_security_group_id = azurerm_network_security_group.redis.id
}

resource "azurerm_subnet" "private_endpoint" {
  name                 = "${var.deployment_name}-private-endpoint"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [local.private_endpoint_subnet_cidr]
}

resource "azurerm_subnet_network_security_group_association" "private_endpoint" {
  subnet_id                 = azurerm_subnet.private_endpoint.id
  network_security_group_id = azurerm_network_security_group.private_endpoint.id
}

resource "azurerm_network_security_group" "private_endpoint" {
  name                = "${var.deployment_name}-private-endpoint-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_group" "gateway-lb" {
  name                = "${var.deployment_name}-gateway-lb-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet_network_security_group_association" "gateway-lb" {
  subnet_id                 = azurerm_subnet.gateway-lb.id
  network_security_group_id = azurerm_network_security_group.gateway-lb.id
}

resource "azurerm_network_security_group" "services" {
  name                = "${var.deployment_name}-services-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet_network_security_group_association" "services" {
  subnet_id                 = azurerm_subnet.services.id
  network_security_group_id = azurerm_network_security_group.services.id
}

