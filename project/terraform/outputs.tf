output "vnet_id" {
  description = "ID of created VNET"
  value       = module.vnet.vnet_id 
}

output "subnet_id" {
  description = "ID of created Subnet"
  value       = module.snet.snet_id 
}

output "log_analytics_workspace_name" {
  value = azurerm_log_analytics_workspace.main.name
}

output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.main.id
}