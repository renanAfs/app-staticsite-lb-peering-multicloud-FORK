output "rg" {
 value = azurerm_resource_group.rg.id
}

output "vnet10" {
 value = azurerm_virtual_network.vnet10.id
}

output "vnet20" {
 value = azurerm_virtual_network.vnet20.id
}

output "snvnet10pub1a" {
 value = azurerm_subnet.sn_vpc10_pub1a.id
}

output "sn_vpc10_pub1b" {
 value = azurerm_subnet.sn_vpc10_pub1b.id
}

output "snvnet20priv" {
 value = azurerm_subnet.snvnet20priv.id
}



