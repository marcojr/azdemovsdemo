variable "env" {
  description = "Environment (dev, prod, etc.)"
}

variable "resource_group_name" {
  description = "Resource group for the ACR"
}

variable "acr_id" {
  description = "ID of the ACR registry"
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID for ACR"
}

variable "log_analytics_workspace_name" {
  description = "The name of the Log Analytics Workspace"
}