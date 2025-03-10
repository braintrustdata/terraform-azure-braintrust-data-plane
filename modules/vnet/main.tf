resource "azurerm_virtual_network" "main" {
  name                = "${var.deployment_name}-${var.vnet_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [local.vnet_address_space_cidr]
}

resource "azurerm_subnet" "services" {
  name                 = "${var.deployment_name}-services"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [local.services_subnet_cidr]
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
