#!/bin/bash
sudo apt update
sudo apt install apache2 -y
echo "<img src=https://cdn.thedevconf.com.br/img/logo/logo-tdc.png>" > /var/www/html/index.html