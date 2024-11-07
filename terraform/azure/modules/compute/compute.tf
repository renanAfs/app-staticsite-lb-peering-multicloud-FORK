#Load Balancer

resource "azurerm_public_ip" "publiciplb" {
  name                = "PublicIPForLB"
  location            = var.rglocation
  resource_group_name = var.rgname
  allocation_method   = "Static"
}

resource "azurerm_lb" "lbvnet10" {
  name                = "TestLoadBalancer"
  location            = var.rglocation
  resource_group_name = var.rgname

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.publiciplb.id
  }
}


#vm1 publica

resource "azurerm_public_ip" "vm01_pip_public1a" {
    name                = "vm01-pip-public"
    location            = var.rglocation
  resource_group_name = var.rgname
    allocation_method   = "Static"
    domain_name_label   = "vm01-pip-public1a"
}

resource "azurerm_network_interface" "vm01_nic_public1a" {
    name                = "vm01-nic-public"
    location            = var.rglocation
  resource_group_name = var.rgname
    ip_configuration {
        name                          = "vm01-ipconfig-public1a"
        subnet_id                     = var.snvnet10pub1a
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.vm01_pip_public1a.id
    }
}

resource "azurerm_virtual_machine" "vm01_public" {
    name                          = "vm01-public"
    location            = var.rglocation
  resource_group_name = var.rgname
    network_interface_ids         = [azurerm_network_interface.vm01_nic_public1a.id]
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
    location            = var.rglocation
  resource_group_name = var.rgname
    allocation_method   = "Static"
    domain_name_label   = "vm02-pip-public"
}

resource "azurerm_network_interface" "vm02_nic_public" {
    name                = "vm02-nic-public"
    location            = var.rglocation
  resource_group_name = var.rgname
    ip_configuration {
        name                          = "vm02-ipconfig-public"
        subnet_id                     = var.snvnet10pub1b
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.vm02_pip_public.id
    }
}

resource "azurerm_virtual_machine" "vm02_public" {
    name                          = "vm02-public"
    location            = var.rglocation
  resource_group_name = var.rgname
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




# #vm privada


# resource "azurerm_network_interface" "vm02_nic_private" {
#     name                = "vm02-nic-private"
#     location            = var.rglocation
#   resource_group_name = var.rgname
#     ip_configuration {
#         name                          = "vm02-ipconfig-private"
#         subnet_id                     = var.snvnet20priv
#         private_ip_address_allocation = "Dynamic"
#     }
# }



# resource "azurerm_virtual_machine" "vm02_private" {
#     name                          = "vm02-private"
#     location            = var.rglocation
#   resource_group_name = var.rgname
#     network_interface_ids         = [azurerm_network_interface.vm02_nic_private.id]
#     vm_size                       = "Standard_D2s_v3"
#     delete_os_disk_on_termination = true
#     storage_image_reference {
#         publisher = "Canonical"
#         offer     = "0001-com-ubuntu-server-jammy"
#         sku       = "22_04-lts"
#         version   = "latest"
#     }
#     storage_os_disk {
#         name              = "vm02-os-disk-private"
#         create_option     = "FromImage"
#         managed_disk_type = "Standard_LRS"
#     }
#     os_profile {
#         computer_name  = "vm02-private"
#         admin_username = "azureuser"
#         admin_password = "Password1234!"
#     }
#     os_profile_linux_config {
#         disable_password_authentication = false
#     }
# }








