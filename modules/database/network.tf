locals {
  db_name = "${var.deployment_name}-database"
}

data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "database" {
  name                 = "${local.db_name}-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = [var.subnet_cidr]
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

resource "azurerm_network_security_group" "database" {
  name                = "${local.db_name}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_rule" "example" {
  count = length(var.allowed_cidrs)

  network_security_group_name = azurerm_network_security_group.database.name
  resource_group_name         = var.resource_group_name

  name                       = "Allow-${var.allowed_cidrs[count.index]}"
  priority                   = 1000 + count.index
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_address_prefix      = var.allowed_cidrs[count.index]
  source_port_range          = "*"
  destination_port_range     = "5432"
  destination_address_prefix = "*"
}

resource "azurerm_subnet_network_security_group_association" "database" {
  subnet_id                 = azurerm_subnet.database.id
  network_security_group_id = azurerm_network_security_group.database.id
}

resource "azurerm_private_dns_zone" "database" {
  name                = "${local.db_name}.postgres.database.azure.com"
  resource_group_name = var.resource_group_name

  depends_on = [azurerm_subnet_network_security_group_association.database]
}

resource "azurerm_private_dns_zone_virtual_network_link" "database" {
  name                  = "${local.db_name}-pdzvnetlink"
  private_dns_zone_name = azurerm_private_dns_zone.database.name
  virtual_network_id    = data.azurerm_virtual_network.vnet.id
  resource_group_name   = var.resource_group_name
}
