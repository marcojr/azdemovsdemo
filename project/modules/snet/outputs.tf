output "snet_name" {
  description = "Name of the Subnet"
  value       = azurerm_subnet.snet.name
}

output "snet_address_prefixes" {
  description = "Address prefixes of the Subnet"
  value       = azurerm_subnet.snet.address_prefixes
}

output "snet_id" {
  description = "ID of the Subnet"
  value       = azurerm_subnet.snet.id
}
