resource "azurerm_subnet" "snet" {
  name                 = "snet-blueharvest-${var.env}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = ["10.0.1.0/24"]

}
