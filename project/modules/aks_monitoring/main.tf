# Enable Azure Monitor for AKS to track performance and activity
resource "azurerm_log_analytics_solution" "aks_monitoring" {
  solution_name         = "ContainerInsights"
  resource_group_name   = var.resource_group_name
  location              = "uksouth"
  workspace_name        = var.log_analytics_workspace_name
  workspace_resource_id = var.log_analytics_workspace_id
  plan {
    product = "OMSGallery/ContainerInsights"
    publisher = "Microsoft"
  }
}

# Create alerts for high CPU usage on AKS
resource "azurerm_monitor_metric_alert" "aks_cpu_alert" {
  name                = "aks-cpu-alert-${var.env}"
  resource_group_name = var.resource_group_name
  scopes              = [var.aks_cluster_id]
  description         = "Alert if CPU usage exceeds 85% in AKS"
  severity            = 2
  criteria {
    metric_namespace = "Microsoft.ContainerService/managedClusters"
    metric_name      = "node_cpu_usage_percentage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 85
  }
}
