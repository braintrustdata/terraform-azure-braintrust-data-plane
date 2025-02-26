output "api_url" {
  value       = "https://${azurerm_cdn_frontdoor_endpoint.main.host_name}"
  description = "The primary endpoint for the dataplane API"
}

output "api_app_name" {
  value       = azurerm_linux_web_app.api.name
  description = "Name of the API App Service"
}

output "api_app_id" {
  value       = azurerm_linux_web_app.api.id
  description = "ID of the API App Service"
}

output "frontdoor_id" {
  value       = azurerm_cdn_frontdoor_profile.main.id
  description = "ID of the Front Door profile"
}
