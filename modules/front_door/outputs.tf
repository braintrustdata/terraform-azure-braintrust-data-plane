output "private_link_service_id" {
  value       = azurerm_private_link_service.aks_api.id
  description = "ID of the Private Link Service"
}

output "private_link_service_name" {
  value       = azurerm_private_link_service.aks_api.name
  description = "Name of the Private Link Service"
}

output "private_link_service_alias" {
  value       = azurerm_private_link_service.aks_api.alias
  description = "Alias of the Private Link Service that can be used to connect to it"
}

output "front_door_profile_id" {
  value       = azurerm_cdn_frontdoor_profile.main.id
  description = "ID of the Azure Front Door profile"
}

output "front_door_profile_name" {
  value       = azurerm_cdn_frontdoor_profile.main.name
  description = "Name of the Azure Front Door profile"
}

output "front_door_endpoint_id" {
  value       = azurerm_cdn_frontdoor_endpoint.api.id
  description = "ID of the Azure Front Door endpoint"
}

output "front_door_endpoint_hostname" {
  value       = azurerm_cdn_frontdoor_endpoint.api.host_name
  description = "Hostname of the Azure Front Door endpoint"
}

output "front_door_endpoint_url" {
  value       = "https://${azurerm_cdn_frontdoor_endpoint.api.host_name}"
  description = "Full URL of the Azure Front Door endpoint"
}

output "front_door_origin_id" {
  value       = azurerm_cdn_frontdoor_origin.api.id
  description = "ID of the Azure Front Door origin"
}
