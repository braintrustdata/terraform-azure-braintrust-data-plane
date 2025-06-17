output "aks" {
  value     = azurerm_kubernetes_cluster.aks
  sensitive = true
}
