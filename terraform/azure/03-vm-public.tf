resource "azurerm_public_ip" "vm01_pip_public" {
    name                = "vm01-pip-public"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    allocation_method   = "Static"
    domain_name_label   = "vm01-pip-public"
}

resource "azurerm_network_interface" "vm01_nic_public" {
    name                = "vm01-nic-public"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    ip_configuration {
        name                          = "vm01-ipconfig-public"
        subnet_id                     = azurerm_subnet.snvnet10pub.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.vm01_pip_public.id
    }
}

resource "azurerm_virtual_machine" "vm01_public" {
    name                          = "vm01-public"
    location                      = azurerm_resource_group.rg.location
    resource_group_name           = azurerm_resource_group.rg.name
    network_interface_ids         = [azurerm_network_interface.vm01_nic_public.id]
    vm_size                       = "Standard_D2s_v3"
    delete_os_disk_on_termination = true
    storage_image_reference {
        publisher = "Canonical"
        offer     = "0001-com-ubuntu-server-jammy"
        sku       = "22_04-lts"
        version   = "latest"
    }
    storage_os_disk {
        name              = "vm01-os-disk-public"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }
    os_profile {
        computer_name  = "vm01-public"
        admin_username = "azureuser"
        admin_password = "Password1234!"
    }
    os_profile_linux_config {
        disable_password_authentication = false
    }
}