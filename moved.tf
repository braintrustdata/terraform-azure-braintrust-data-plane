# Resource group is now conditional
moved {
  from = azurerm_resource_group.main
  to   = azurerm_resource_group.main[0]
}
