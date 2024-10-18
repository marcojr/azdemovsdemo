resource "azurerm_container_registry" "acr" {
  name                = "acrblueharvest${var.env}"
  resource_group_name = var.resource_group_name
  location            = "uksouth"
  sku                 = "Standard"
  admin_enabled       = false

  tags = {
    environment = var.env
    project     = "blueharvest"
  }
}