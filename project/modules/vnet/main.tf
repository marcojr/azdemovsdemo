
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-blueharvest-${var.env}"
  address_space       = ["10.0.0.0/16"]
  location            = "uksouth"
  resource_group_name = var.resource_group_name

  tags = {
    environment = var.env
    project     = "blueharvest"
  }
}