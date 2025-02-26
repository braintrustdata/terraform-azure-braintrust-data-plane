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

output "postgres_database_password" {
  value       = random_password.postgres.result
  description = "Password for the PostgreSQL database"
  sensitive   = true
}

output "postgres_database_port" {
  value       = 5432
  description = "Port for the PostgreSQL database"
}
