provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "main" {
  name     = "rg-blueharvest-${var.env}"
  location = "uksouth"
}

# Module to deploy Azure Container Registry (ACR)
module "acr" {
  source              = "../modules/acr"
  env                 = var.env
  resource_group_name = azurerm_resource_group.main.name
}

# Module to deploy Azure Kubernetes Service (AKS)
module "aks" {
  source              = "../modules/aks"
  env                 = var.env
  resource_group_name = azurerm_resource_group.main.name
  acr_name            = module.acr.acr_name  
  subscription_id     = var.subscription_id
  log_analytics_workspace_name = azurerm_log_analytics_workspace.main.name
}

# Module to deploy Virtual Network (VNet)
module "vnet" {
  source              = "../modules/vnet"
  env                 = var.env
  resource_group_name = azurerm_resource_group.main.name
}

# Module to deploy Subnet within the VNet
module "snet" {
  source              = "../modules/snet"
  env                 = var.env
  resource_group_name = azurerm_resource_group.main.name
  vnet_name           = module.vnet.vnet_name
}

# Azure Monitor Log Analytics Workspace for monitoring and logs
resource "azurerm_log_analytics_workspace" "main" {
  name                = "log-analytics-${var.env}"
  location            = "uksouth"
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
}

# Enable monitoring and diagnostics for AKS
module "aks_monitoring" {
  source                  = "../modules/aks_monitoring"
  env                     = var.env
  resource_group_name      = azurerm_resource_group.main.name
  aks_cluster_id           = module.aks.aks_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  log_analytics_workspace_name = azurerm_log_analytics_workspace.main.name
}

# Enable diagnostics for ACR
module "acr_monitoring" {
  source                  = "../modules/acr_monitoring"
  env                     = var.env
  resource_group_name      = azurerm_resource_group.main.name
  acr_id                   = module.acr.acr_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  log_analytics_workspace_name = azurerm_log_analytics_workspace.main.name
}