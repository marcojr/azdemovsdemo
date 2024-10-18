output "acr_name" {
  description = "Name of the Azure Container Registry"
  value       = azurerm_container_registry.acr.name
}

output "acr_login_server" {
  description = "Login server for the ACR"
  value       = azurerm_container_registry.acr.login_server
}

output "acr_id" {
  description = "ID of the Container Registry"
  value       = azurerm_container_registry.acr.id
}

