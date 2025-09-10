locals {
  db_name    = "${var.deployment_name}-database"
  pg_db_name = "braintrust"
  pg_user    = "postgres"
}

resource "azurerm_postgresql_flexible_server" "main" {
  name                = local.db_name
  resource_group_name = var.resource_group_name

  location = var.location
  version  = var.postgres_version

  public_network_access_enabled = false

  administrator_login    = local.pg_user
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
    key_vault_key_id                  = azurerm_key_vault_key.postgres_cmk.id
    primary_user_assigned_identity_id = azurerm_user_assigned_identity.main.id
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.main.id]
  }

  lifecycle {
    ignore_changes = [
      high_availability[0].standby_availability_zone,
      zone,
      storage_mb,
      storage_tier,
    ]
  }
}

resource "azurerm_postgresql_flexible_server_database" "main" {
  name      = local.pg_db_name
  server_id = azurerm_postgresql_flexible_server.main.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}

resource "azurerm_key_vault_secret" "postgres_password" {
  name         = "postgres-password"
  value        = random_password.postgres_password.result
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "postgres_connection_string" {
  name         = "postgres-connection-string"
  value        = "postgres://${local.pg_user}:${azurerm_key_vault_secret.postgres_password.value}@${azurerm_postgresql_flexible_server.main.fqdn}:5432/${local.pg_db_name}?sslmode=require"
  key_vault_id = var.key_vault_id
}

resource "random_password" "postgres_password" {
  length  = 16
  special = false
}

resource "azurerm_key_vault_key" "postgres_cmk" {
  name         = "${local.db_name}-cmk"
  key_vault_id = var.key_vault_id
  key_type     = "RSA"
  key_size     = 4096

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}

resource "azurerm_postgresql_flexible_server_configuration" "extensions" {
  name      = "shared_preload_libraries"
  server_id = azurerm_postgresql_flexible_server.main.id
  value     = "pg_stat_statements,pg_hint_plan,pg_cron"
}

resource "azurerm_postgresql_flexible_server_configuration" "allow_extensions" {
  name      = "azure.extensions"
  server_id = azurerm_postgresql_flexible_server.main.id
  value     = "pg_stat_statements,pg_hint_plan,pg_cron,pg_partman"
}

resource "azurerm_postgresql_flexible_server_configuration" "pg_cron_db" {
  name      = "cron.database_name"
  server_id = azurerm_postgresql_flexible_server.main.id
  value     = "braintrust"
}

resource "azurerm_postgresql_flexible_server_configuration" "statement_timeout" {
  name      = "statement_timeout"
  server_id = azurerm_postgresql_flexible_server.main.id
  value     = "3600000"
}

resource "azurerm_postgresql_flexible_server_configuration" "collector_database_activity" {
  name      = "metrics.collector_database_activity"
  server_id = azurerm_postgresql_flexible_server.main.id
  value     = "ON"
}

resource "azurerm_postgresql_flexible_server_configuration" "autovacuum_diagnostics" {
  name      = "metrics.autovacuum_diagnostics"
  server_id = azurerm_postgresql_flexible_server.main.id
  value     = "ON"
}

