output "rgname" {
 value = azurerm_resource_group.rg.name
}

output "rglocation" {
 value = azurerm_resource_group.rg.location
}

output "vnet10" {
 value = azurerm_virtual_network.vnet10.id
}

output "vnet20" {
 value = azurerm_virtual_network.vnet20.id
}

output "snvnet10pub1a" {
 value = azurerm_subnet.snvnet10pub1a.id
}

output "snvnet10pub1b" {
 value = azurerm_subnet.snvnet10pub1b.id
}

output "snvnet20priv" {
 value = azurerm_subnet.snvnet20priv.id
}



