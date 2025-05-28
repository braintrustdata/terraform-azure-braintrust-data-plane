output "resource_group_name" {
  value       = azurerm_resource_group.main.name
  description = "Name of the resource group containing Braintrust resources"
}

output "main_vnet_id" {
  value       = var.existing_vnet.id == "" ? module.main_vnet[0].vnet_id : var.existing_vnet.id
  description = "ID of the main VNet that contains the Braintrust resources"
}

output "main_vnet_name" {
  value       = var.existing_vnet.id == "" ? module.main_vnet[0].vnet_name : var.existing_vnet.name
  description = "Name of the main VNet that contains the Braintrust resources"
}

output "main_vnet_address_space" {
  value       = var.existing_vnet.id == "" ? module.main_vnet[0].vnet_address_space : var.existing_vnet.address_space
  description = "Address space of the main VNet"
}

output "services_subnet_id" {
  value       = var.existing_vnet.id == "" ? module.main_vnet[0].services_subnet_id : var.existing_vnet.services_subnet_id
  description = "ID of the services subnet"
}

output "services_network_security_group_id" {
  value       = var.existing_vnet.id == "" ? module.main_vnet[0].services_network_security_group_id : var.existing_vnet.services_network_security_group_id
  description = "ID of the services network security group"
}

output "private_endpoint_subnet_id" {
  value       = var.existing_vnet.id == "" ? module.main_vnet[0].private_endpoint_subnet_id : var.existing_vnet.private_endpoint_subnet_id
  description = "ID of the private endpoint subnet"
}

output "private_endpoint_network_security_group_id" {
  value       = var.existing_vnet.id == "" ? module.main_vnet[0].private_endpoint_network_security_group_id : var.existing_vnet.private_endpoint_network_security_group_id
  description = "ID of the private endpoint subnet's network security group"
}

output "postgres_database_id" {
  value       = module.database.postgres_database_id
  description = "ID of the main Braintrust Postgres database"
}

output "postgres_database_fqdn" {
  value       = module.database.postgres_database_fqdn
  description = "FQDN of the PostgreSQL database"
}

output "postgres_database_name" {
  value       = module.database.postgres_database_name
  description = "Name of the PostgreSQL database"
}

output "postgres_database_username" {
  value       = module.database.postgres_database_username
  description = "Username for the PostgreSQL database"
}

output "postgres_password_secret_id" {
  value       = module.database.postgres_password_secret_id
  description = "ID of the Key Vault secret for the PostgreSQL database"
}

output "postgres_password_secret_name" {
  value       = module.database.postgres_password_secret_name
  description = "Name of the Key Vault secret for the PostgreSQL database"
}

output "postgres_application_security_group_name" {
  value       = module.database.postgres_application_security_group_name
  description = "Name of the postgres application security group"
}

output "redis_id" {
  value       = module.redis.redis_id
  description = "ID of the Redis instance"
}

output "redis_hostname" {
  value       = module.redis.redis_hostname
  description = "The hostname of the Redis Cache"
}

output "redis_ssl_port" {
  value       = module.redis.redis_ssl_port
  description = "The SSL port of the Redis Cache"
}

output "redis_password_secret_id" {
  value       = module.redis.redis_password_secret_id
  description = "The ID of the Key Vault secret for the Redis Cache password"
}

output "redis_password_secret_name" {
  value       = module.redis.redis_password_secret_name
  description = "The name of the Key Vault secret for the Redis Cache password"
}

output "redis_application_security_group_name" {
  value       = module.redis.redis_application_security_group_name
  description = "Name of the redis application security group"
}

output "storage_account_id" {
  value       = module.storage.storage_account_id
  description = "The ID of the storage account"
}

output "storage_account_name" {
  value       = module.storage.storage_account_name
  description = "The name of the storage account"
}

output "primary_blob_endpoint" {
  value       = module.storage.primary_blob_endpoint
  description = "The primary blob endpoint URL"
}

output "brainstore_container_name" {
  value       = module.storage.brainstore_container_name
  description = "The name of the brainstore container"
}

output "responses_container_name" {
  value       = module.storage.responses_container_name
  description = "The name of the responses container"
}

output "code_bundles_container_name" {
  value       = module.storage.code_bundles_container_name
  description = "The name of the code-bundles container"
}

output "storage_identity_id" {
  value       = module.storage.storage_identity_id
  description = "The ID of the user-assigned managed identity used by the storage account"
}

output "storage_identity_principal_id" {
  value       = module.storage.storage_identity_principal_id
  description = "The principal ID of the user-assigned managed identity used by the storage account"
}

output "key_vault_id" {
  value       = module.kms[0].key_vault_id
  description = "The ID of the Key Vault"
}

output "key_vault_name" {
  value       = module.kms[0].key_vault_name
  description = "The name of the Key Vault"
}

output "key_vault_uri" {
  value       = module.kms[0].key_vault_uri
  description = "The URI of the Key Vault"
}

output "key_vault_application_security_group_name" {
  value       = module.kms[0].key_vault_application_security_group_name
  description = "Name of the key vault application security group"
}

output "brainstore_identity_id" {
  value       = module.services.brainstore_identity_id
  description = "ID of the brainstore managed identity"
}

output "api_handler_identity_id" {
  value       = module.services.api_handler_identity_id
  description = "ID of the api-handler managed identity"
}

output "brainstore_identity_client_id" {
  value       = module.services.brainstore_identity_client_id
  description = "Client ID of the brainstore managed identity"
}

output "api_handler_identity_client_id" {
  value       = module.services.api_handler_identity_client_id
  description = "Client ID of the api-handler managed identity"
}

output "brainstore_identity_principal_id" {
  value       = module.services.brainstore_identity_principal_id
  description = "Principal ID of the brainstore managed identity"
}

output "api_handler_identity_principal_id" {
  value       = module.services.api_handler_identity_principal_id
  description = "Principal ID of the api-handler managed identity"
}
