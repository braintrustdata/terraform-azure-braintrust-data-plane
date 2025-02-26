resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.deployment_name}-${var.vnet_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.vnet_address_space]

  tags = {
    deployment = var.deployment_name
  }
}

resource "azurerm_subnet" "public" {
  name                 = "snet-${var.deployment_name}-${var.vnet_name}-public"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.public_subnet_cidr]
}

resource "azurerm_subnet" "private_1" {
  name                 = "snet-${var.deployment_name}-${var.vnet_name}-private-1"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.private_subnet_1_cidr]
  service_endpoints    = ["Microsoft.Sql", "Microsoft.Storage", "Microsoft.KeyVault", "Microsoft.Web"]
}

resource "azurerm_subnet" "private_2" {
  name                 = "snet-${var.deployment_name}-${var.vnet_name}-private-2"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.private_subnet_2_cidr]
  service_endpoints    = ["Microsoft.Sql", "Microsoft.Storage", "Microsoft.KeyVault", "Microsoft.Web"]
}

resource "azurerm_subnet" "private_3" {
  name                 = "snet-${var.deployment_name}-${var.vnet_name}-private-3"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.private_subnet_3_cidr]
  service_endpoints    = ["Microsoft.Sql", "Microsoft.Storage", "Microsoft.KeyVault", "Microsoft.Web"]
}

resource "azurerm_network_security_group" "default" {
  name                = "nsg-${var.deployment_name}-${var.vnet_name}"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = {
    deployment = var.deployment_name
  }
}

resource "azurerm_subnet_network_security_group_association" "public" {
  subnet_id                 = azurerm_subnet.public.id
  network_security_group_id = azurerm_network_security_group.default.id
}

resource "azurerm_subnet_network_security_group_association" "private_1" {
  subnet_id                 = azurerm_subnet.private_1.id
  network_security_group_id = azurerm_network_security_group.default.id
}

resource "azurerm_subnet_network_security_group_association" "private_2" {
  subnet_id                 = azurerm_subnet.private_2.id
  network_security_group_id = azurerm_network_security_group.default.id
}

resource "azurerm_subnet_network_security_group_association" "private_3" {
  subnet_id                 = azurerm_subnet.private_3.id
  network_security_group_id = azurerm_network_security_group.default.id
}

resource "azurerm_route_table" "public" {
  name                = "rt-${var.deployment_name}-${var.vnet_name}-public"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = {
    deployment = var.deployment_name
  }
}

resource "azurerm_route_table" "private" {
  name                = "rt-${var.deployment_name}-${var.vnet_name}-private"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = {
    deployment = var.deployment_name
  }
}

resource "azurerm_subnet_route_table_association" "public" {
  subnet_id      = azurerm_subnet.public.id
  route_table_id = azurerm_route_table.public.id
}

resource "azurerm_subnet_route_table_association" "private_1" {
  subnet_id      = azurerm_subnet.private_1.id
  route_table_id = azurerm_route_table.private.id
}

resource "azurerm_subnet_route_table_association" "private_2" {
  subnet_id      = azurerm_subnet.private_2.id
  route_table_id = azurerm_route_table.private.id
}

resource "azurerm_subnet_route_table_association" "private_3" {
  subnet_id      = azurerm_subnet.private_3.id
  route_table_id = azurerm_route_table.private.id
}
