output "clickhouse_instance_private_ip" {
  value       = var.clickhouse_instance_count > 0 ? azurerm_network_interface.clickhouse[0].private_ip_address : null
  description = "Private IP address of the Clickhouse instance"
}

output "clickhouse_secret_id" {
  value       = azurerm_key_vault_secret.clickhouse_password.id
  description = "ID of the Clickhouse secret in Key Vault"
}

output "clickhouse_storage_account_name" {
  value       = azurerm_storage_account.clickhouse.name
  description = "Name of the Clickhouse storage account"
}
