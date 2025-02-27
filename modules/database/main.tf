locals {
  db_name = "${var.deployment_name}-database"
}

resource "azurerm_postgresql_flexible_server" "main" {
  name                = local.db_name
  resource_group_name = var.resource_group_name

  location = var.location
  version  = var.postgres_version

  public_network_access_enabled = false
  delegated_subnet_id           = var.subnet_id

  administrator_login    = "postgres"
  administrator_password = azurerm_key_vault_secret.postgres_password.value

  sku_name          = var.postgres_sku_name
  auto_grow_enabled = true
  storage_mb        = var.postgres_storage_mb
  storage_tier      = var.postgres_storage_tier

  backup_retention_days = 7

  authentication {
    password_auth_enabled = true
  }

  high_availability {
    mode = "SameZone"
  }

  customer_managed_key {
    key_vault_key_id                  = var.key_vault_id
    primary_user_assigned_identity_id = azurerm_user_assigned_identity.postgres_cmk.id
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.postgres_cmk.id]
  }

  lifecycle {
    ignore_changes = [
      high_availability[0].standby_availability_zone
    ]
  }
}

resource "azurerm_postgresql_flexible_server_database" "main" {
  name      = "braintrust"
  server_id = azurerm_postgresql_flexible_server.main.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}

resource "azurerm_key_vault_secret" "postgres_password" {
  name         = "${local.db_name}-password"
  value        = random_password.postgres.result
  key_vault_id = var.key_vault_id
}

resource "random_password" "postgres" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_user_assigned_identity" "postgres_cmk" {
  name                = "${local.db_name}-cmk-identity"
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_key_vault_access_policy" "postgres_cmk" {
  key_vault_id = var.key_vault_id
  tenant_id    = azurerm_user_assigned_identity.postgres_cmk.tenant_id
  object_id    = azurerm_user_assigned_identity.postgres_cmk.principal_id

  key_permissions = [
    "Get",
    "WrapKey",
    "UnwrapKey"
  ]
}
