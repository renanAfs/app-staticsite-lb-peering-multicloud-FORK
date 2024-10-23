resource "azurerm_resource_group" "rg" {
    name     = "rg-staticsitelbpeering"
    location = "brazilsouth"
}

resource "azurerm_virtual_network" "vnet10" {
    name                = "vnet10"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    address_space       = ["10.0.0.0/16"]
}

resource "azurerm_virtual_network" "vnet20" {
    name                = "vnet20"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    address_space       = ["20.0.0.0/16"]
}

resource "azurerm_subnet" "snvnet10pub" {
    name                 = "snvnet10pub"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet10.name
    address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "snvnet20priv" {
    name                 = "snvnet20priv"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet20.name
    address_prefixes     = ["20.0.1.0/24"]
}