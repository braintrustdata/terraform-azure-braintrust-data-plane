output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}

output "cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "aks_identity_client_id" {
  value = azurerm_user_assigned_identity.aks_identity.client_id
}

output "aks_identity_object_id" {
  value = azurerm_user_assigned_identity.aks_identity.principal_id
}

output "workload_identity_client_id" {
  value       = azurerm_user_assigned_identity.braintrust_service_account.client_id
  description = "The client ID of the Braintrust workload identity (used in Kubernetes service accounts)"
}

output "workload_identity_principal_id" {
  value       = azurerm_user_assigned_identity.braintrust_service_account.principal_id
  description = "The principal ID of the Braintrust workload identity"
}
