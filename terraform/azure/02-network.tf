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

resource "azurerm_virtual_network_peering" "vnet10-to-vnet20" {
  name                      = "vnet10-to-vnet20"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.vnet10.name
  remote_virtual_network_id = azurerm_virtual_network.vnet20.id
}

resource "azurerm_virtual_network_peering" "vnet20-to-vnet10" {
  name                      = "vnet20-to-vnet10"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.vnet20.name
  remote_virtual_network_id = azurerm_virtual_network.vnet10.id
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

resource "azurerm_network_security_group" "nsgvnet10" {
    name                = "nsgvnet10"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    security_rule {
        name                       = "AllowInternetSshInbound"
        priority                   = 1011
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "Internet"
        destination_address_prefix = "*"
    }
}

resource "azurerm_network_security_group" "nsgvnet20" {
    name                = "nsgvnet20"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    security_rule {
        name                       = "DenyInternetInbound"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Deny"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "Internet"
        destination_address_prefix = "*"
    }
}

resource "azurerm_subnet_network_security_group_association" "nsgsnvnet10pub" {
    subnet_id                 = azurerm_subnet.snvnet10pub.id
    network_security_group_id = azurerm_network_security_group.nsgvnet10.id
}

resource "azurerm_subnet_network_security_group_association" "nsgsnvnet20priv" {
    subnet_id                 = azurerm_subnet.snvnet20priv.id
    network_security_group_id = azurerm_network_security_group.nsgvnet20.id
}