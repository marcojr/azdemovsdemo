variable "env" {
  description = "Environment (dev, prod, etc.)"
}

variable "resource_group_name" {
  description = "Resource group for the AKS cluster"
}

variable "aks_cluster_id" {
  description = "ID of the AKS cluster"
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID for AKS"
}

variable "log_analytics_workspace_name" {
  description = "The name of the Log Analytics Workspace."
}

