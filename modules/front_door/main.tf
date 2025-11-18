resource "azurerm_private_link_service" "aks_api" {
  name                = "${var.deployment_name}-aks-api-pls"
  resource_group_name = var.resource_group_name
  location            = var.location

  auto_approval_subscription_ids = [data.azurerm_client_config.current.subscription_id]

  nat_ip_configuration {
    name      = "primary"
    subnet_id = var.private_link_service_subnet_id
    primary   = true
  }

  load_balancer_frontend_ip_configuration_ids = [
    var.load_balancer_frontend_ip_config_id
  ]
}

resource "azurerm_cdn_frontdoor_profile" "main" {
  name                = "${var.deployment_name}-afd"
  resource_group_name = var.resource_group_name
  sku_name            = "Premium_AzureFrontDoor"
}

resource "azurerm_cdn_frontdoor_endpoint" "api" {
  name                     = "${var.deployment_name}-api-endpoint"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main.id
}

resource "azurerm_cdn_frontdoor_origin_group" "api" {
  name                     = "${var.deployment_name}-api-origin-group"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main.id

  load_balancing {
    sample_size                        = 4
    successful_samples_required        = 3
    additional_latency_in_milliseconds = 50
  }

  health_probe {
    protocol            = "Http"
    path                = "/"
    request_type        = "GET"
    interval_in_seconds = 100
  }
}

resource "azurerm_cdn_frontdoor_origin" "api" {
  name                           = "${var.deployment_name}-api-origin"
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.api.id
  enabled                        = true
  host_name                      = var.api_backend_address
  http_port                      = var.api_backend_port
  https_port                     = 443
  origin_host_header             = var.api_backend_address
  priority                       = 1
  weight                         = 1000
  certificate_name_check_enabled = true

  private_link {
    request_message        = "Private Link request from Azure Front Door for ${var.deployment_name}"
    location               = var.location
    private_link_target_id = azurerm_private_link_service.aks_api.id
  }
}

resource "azurerm_cdn_frontdoor_route" "api" {
  name                          = "${var.deployment_name}-api-route"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.api.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.api.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.api.id]
  supported_protocols           = ["Http", "Https"]
  patterns_to_match             = ["/*"]
  forwarding_protocol           = "HttpOnly"
  link_to_default_domain        = true
  https_redirect_enabled        = true
}
