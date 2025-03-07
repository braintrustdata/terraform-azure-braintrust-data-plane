output "postgres_database_id" {
  value       = azurerm_postgresql_flexible_server.main.id
  description = "ID of the PostgreSQL database"
}

output "postgres_database_fqdn" {
  value       = azurerm_postgresql_flexible_server.main.fqdn
  description = "FQDN of the PostgreSQL database"
}

output "postgres_database_username" {
  value       = azurerm_postgresql_flexible_server.main.administrator_login
  description = "Username for the PostgreSQL database"
}

output "postgres_password_secret_id" {
  value       = azurerm_key_vault_secret.postgres_password.id
  description = "ID of the Key Vault secret for the PostgreSQL database"
}

output "postgres_application_security_group_name" {
  value       = azurerm_application_security_group.main_db_endpoint.name
  description = "Name of the postgres application security group"
}
