# Enable diagnostic logging and monitoring for ACR
resource "azurerm_monitor_diagnostic_setting" "acr_diagnostics" {
  name                       = "acr-diagnostics-${var.env}"
  target_resource_id         = var.acr_id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "ContainerRegistryLoginEvents"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
