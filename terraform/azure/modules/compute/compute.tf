#Load Balancer

resource "azurerm_public_ip" "publiciplb" {
  name                = "PublicIPForLB"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

resource "azurerm_lb" "lbvnet10" {
  name                = "TestLoadBalancer"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.publiciplb.id
  }
}


#vm1 publica

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
        subnet_id                     = azurerm_subnet.snvnet10pub1a.id
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
        custom_data = 
        custom_data    = <<-EOF
         #!/bin/bash
            sudo apt-get update
            sudo apt-get install -y python3 python3-pip
            pip3 install flask
             cat << 'EOF2' > /home/ubuntu/app.py
            from flask import Flask
             app = Flask(__name__)
             @app.route('/')
             def home():
            return "Hello, Azure from Flask!"
             if __name__ == '__main__':
          app.run(host='0.0.0.0', port=5000)
          EOF2
          nohup python3 /home/ubuntu/app.py &
        EOF
    }
    os_profile_linux_config {
        disable_password_authentication = false
    }
}

#vm2 publica

resource "azurerm_public_ip" "vm02_pip_public" {
    name                = "vm02-pip-public"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    allocation_method   = "Static"
    domain_name_label   = "vm02-pip-public"
}

resource "azurerm_network_interface" "vm02_nic_public" {
    name                = "vm02-nic-public"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    ip_configuration {
        name                          = "vm02-ipconfig-public"
        subnet_id                     = azurerm_subnet.snvnet10pub1b.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.vm02_pip_public.id
    }
}

resource "azurerm_virtual_machine" "vm02_public" {
    name                          = "vm02-public"
    location                      = azurerm_resource_group.rg.location
    resource_group_name           = azurerm_resource_group.rg.name
    network_interface_ids         = [azurerm_network_interface.vm02_nic_public.id]
    vm_size                       = "Standard_D2s_v3"
    delete_os_disk_on_termination = true
    storage_image_reference {
        publisher = "Canonical"
        offer     = "0001-com-ubuntu-server-jammy"
        sku       = "22_04-lts"
        version   = "latest"
    }
    storage_os_disk {
        name              = "vm02-os-disk-public"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }
    os_profile {
        computer_name  = "vm02-public"
        admin_username = "azureuser"
        admin_password = "Password1234!"
        custom_data    = <<-EOF
         #!/bin/bash
            sudo apt-get update
            sudo apt-get install -y python3 python3-pip
            pip3 install flask
             cat << 'EOF2' > /home/ubuntu/app.py
            from flask import Flask
             app = Flask(__name__)
             @app.route('/')
             def home():
            return "Hello, Azure from Flask!"
             if __name__ == '__main__':
          app.run(host='0.0.0.0', port=5000)
          EOF2
          nohup python3 /home/ubuntu/app.py &
        EOF
    }
    os_profile_linux_config {
        disable_password_authentication = false
    }
}




#vm privada


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








