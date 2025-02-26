resource "azurerm_service_plan" "main" {
  name                = "asp-${var.deployment_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = "P1v2"

  tags = {
    deployment = var.deployment_name
  }
}

resource "azurerm_linux_web_app" "api" {
  name                = "app-${var.deployment_name}-api"
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.main.id
  https_only          = true

  site_config {
    always_on           = true
    minimum_tls_version = "1.2"
    ftps_state          = "Disabled"
    health_check_path   = "/health"
    application_stack {
      node_version = "18-lts"
    }
    cors {
      allowed_origins     = concat(["https://${var.braintrust_org_name}.braintrust.com"], var.whitelisted_origins)
      support_credentials = true
    }
  }

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "WEBSITE_RUN_FROM_PACKAGE"            = "1"
    "WEBSITE_NODE_DEFAULT_VERSION"        = "~18"
    "WEBSITE_HEALTHCHECK_MAXPINGFAILURES" = "10"
    "SCALE_OUT_CAPACITY"                  = var.api_handler_scale_out_capacity

    # Database settings
    "POSTGRES_HOST"     = var.postgres_host
    "POSTGRES_PORT"     = var.postgres_port
    "POSTGRES_USER"     = var.postgres_username
    "POSTGRES_PASSWORD" = var.postgres_password
    "POSTGRES_DB"       = "braintrust"

    # Redis settings
    "REDIS_HOST"     = var.redis_host
    "REDIS_PORT"     = var.redis_port
    "REDIS_PASSWORD" = var.redis_password
    "REDIS_TLS"      = "true"

    # Clickhouse settings (if enabled)
    "CLICKHOUSE_HOST"      = var.clickhouse_host
    "CLICKHOUSE_SECRET_ID" = var.clickhouse_secret_id

    # Rate limiting
    "OUTBOUND_RATE_LIMIT_WINDOW_MINUTES" = var.outbound_rate_limit_window_minutes
    "OUTBOUND_RATE_LIMIT_MAX_REQUESTS"   = var.outbound_rate_limit_max_requests

    # Organization
    "BRAINTRUST_ORG_NAME" = var.braintrust_org_name
  }

  tags = {
    deployment = var.deployment_name
  }
}

# Create Front Door profile
resource "azurerm_cdn_frontdoor_profile" "main" {
  name                = "fd-${var.deployment_name}"
  resource_group_name = var.resource_group_name
  sku_name            = "Standard_AzureFrontDoor"

  tags = {
    deployment = var.deployment_name
  }
}

# Create Front Door endpoint
resource "azurerm_cdn_frontdoor_endpoint" "main" {
  name                     = "fdend-${var.deployment_name}"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main.id
}

# Create Front Door origin group
resource "azurerm_cdn_frontdoor_origin_group" "api" {
  name                     = "api-origin-group"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main.id

  load_balancing {
    sample_size                 = 4
    successful_samples_required = 3
  }

  health_probe {
    path                = "/health"
    protocol            = "Https"
    interval_in_seconds = 30
  }
}

# Create Front Door origin
resource "azurerm_cdn_frontdoor_origin" "api" {
  name                          = "api-origin"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.api.id

  enabled            = true
  host_name          = azurerm_linux_web_app.api.default_hostname
  http_port          = 80
  https_port         = 443
  origin_host_header = azurerm_linux_web_app.api.default_hostname
  priority           = 1
  weight             = 1000
}

# Create Front Door route
resource "azurerm_cdn_frontdoor_route" "api" {
  name                          = "api-route"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.main.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.api.id

  enabled                = true
  forwarding_protocol    = "HttpsOnly"
  https_redirect_enabled = true
  patterns_to_match      = ["/*"]
  supported_protocols    = ["Http", "Https"]
}

# Custom domain configuration (if provided)
resource "azurerm_cdn_frontdoor_custom_domain" "custom" {
  count                    = var.custom_domain != null ? 1 : 0
  name                     = "custom-domain"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main.id
  host_name                = var.custom_domain

  tls {
    certificate_type    = "CustomerCertificate"
    minimum_tls_version = "TLS12"
  }
}
