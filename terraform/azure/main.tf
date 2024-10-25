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

resource "azurerm_virtual_network_peering" "vnet10-to-vnet20" {
  name                      = "vnet10-to-vnet20"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.vnet10.name
  remote_virtual_network_id = azurerm_virtual_network.vnet20.id
  allow_forwarded_traffic   = true
}

# resource "azurerm_virtual_network_peering" "vnet20-to-vnet10" {
#   name                      = "vnet20-to-vnet10"
#   resource_group_name       = azurerm_resource_group.rg.name
#   virtual_network_name      = azurerm_virtual_network.vnet20.name
#   remote_virtual_network_id = azurerm_virtual_network.vnet10.id
# }

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
        name                       = "Inbound-All-HTTP"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    security_rule {
        name                       = "Inbound-All-FTP"
        priority                   = 1011
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}

resource "azurerm_network_security_group" "nsgvnet20" {
    name                = "nsgvnet20"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    security_rule {
        name                       = "Inbound-Internet-All"
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

resource "azurerm_availability_set" "as" {
    name                = "as"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
}

data "template_file" "cloud_init" {
    template = "${file("./scripts/cloud_init.sh")}"
}

resource "azurerm_public_ip" "vm01-pip" {
    name                = "vm01-pip"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    allocation_method   = "Static"
    domain_name_label   = "vm01-pip"
}

resource "azurerm_network_interface" "vm01-nic" {
    name                = "vm01-nic"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    ip_configuration {
        name                          = "vm01-ipconfig"
        subnet_id                     = azurerm_subnet.subnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.vm01-pip.id
    }
}

resource "azurerm_virtual_machine" "vm01" {
    name                             = "vm01"
    location                         = azurerm_resource_group.rg.location
    resource_group_name              = azurerm_resource_group.rg.name
    network_interface_ids            = [azurerm_network_interface.vm01-nic.id]
    availability_set_id              = azurerm_availability_set.as.id
    vm_size                          = "Standard_DS1_v2"
    delete_os_disk_on_termination    = true
    delete_data_disks_on_termination = true
    storage_image_reference {
        publisher = "Canonical"
        offer     = "0001-com-ubuntu-server-jammy"
        sku       = "22_04-lts"
        version   = "latest"
    }
    storage_os_disk {
        name              = "vm01-os-disk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }
    os_profile {
        computer_name  = "vm01"
        admin_username = "vmuser"
        admin_password = "Password1234!"
        custom_data    = "${base64encode(data.template_file.cloud_init.rendered)}"
    }
    os_profile_linux_config {
        disable_password_authentication = false
    }
}