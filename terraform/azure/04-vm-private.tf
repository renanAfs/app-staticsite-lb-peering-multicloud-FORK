resource "azurerm_network_interface" "vm02_nic_private" {
    name                = "vm02-nic-private"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    ip_configuration {
        name                          = "vm02-ipconfig-private"
        subnet_id                     = azurerm_subnet.snvnet20priv.id
        private_ip_address_allocation = "Dynamic"
    }
}

resource "azurerm_virtual_machine" "vm02_private" {
    name                          = "vm02-private"
    location                      = azurerm_resource_group.rg.location
    resource_group_name           = azurerm_resource_group.rg.name
    network_interface_ids         = [azurerm_network_interface.vm02_nic_private.id]
    vm_size                       = "Standard_D2s_v3"
    delete_os_disk_on_termination = true
    storage_image_reference {
        publisher = "Canonical"
        offer     = "0001-com-ubuntu-server-jammy"
        sku       = "22_04-lts"
        version   = "latest"
    }
    storage_os_disk {
        name              = "vm02-os-disk-private"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }
    os_profile {
        computer_name  = "vm02-private"
        admin_username = "azureuser"
        admin_password = "Password1234!"
    }
    os_profile_linux_config {
        disable_password_authentication = false
    }
}