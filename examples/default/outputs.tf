output "resource_group_name" {
  description = "Name of the resource group"
  value       = module.braintrust.resource_group_name
}

output "postgres_database_fqdn" {
  description = "FQDN of the PostgreSQL database"
  value       = module.braintrust.postgres_database_fqdn
}

output "postgres_database_name" {
  description = "Name of the PostgreSQL database"
  value       = module.braintrust.postgres_database_name
}

output "postgres_password_secret_name" {
  description = "Name of the Key Vault secret containing the PostgreSQL password"
  value       = module.braintrust.postgres_password_secret_name
}

output "redis_hostname" {
  description = "Hostname of the Redis cache"
  value       = module.braintrust.redis_hostname
}

output "redis_password_secret_name" {
  description = "Name of the Key Vault secret containing the Redis password"
  value       = module.braintrust.redis_password_secret_name
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = module.braintrust.storage_account_name
}

output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = module.braintrust.key_vault_name
}

output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = module.braintrust.key_vault_uri
}

output "connect_to_cluster" {
  description = "Command to connect to the AKS cluster"
  value       = "az aks get-credentials --resource-group ${module.braintrust.resource_group_name} --name ${module.braintrust.aks_cluster_name}"
}
