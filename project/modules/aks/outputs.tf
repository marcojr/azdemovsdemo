output "aks_name" {
  description = "Name of the AKS Cluster"
  value       = azurerm_kubernetes_cluster.aks.name
}

output "aks_fqdn" {
  description = "Fully qualified domain name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.fqdn
}

output "aks_identity_principal_id" {
  description = "The Principal ID for AKS Managed Identity"
  value       = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}

output "aks_id" {
  value = azurerm_kubernetes_cluster.aks.id
  description = "The ID of the AKS Cluster"
}
