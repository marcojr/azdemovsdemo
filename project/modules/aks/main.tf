resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-blueharvest-${var.env}"
  location            = "uksouth"
  resource_group_name = var.resource_group_name
  dns_prefix          = "blueharvest-${var.env}-dns"

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = var.env
    project     = "blueharvest"
  }
}

resource "azurerm_role_assignment" "acr_pull" {
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name = "AcrPull"
  scope                = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.ContainerRegistry/registries/${var.acr_name}"
}


