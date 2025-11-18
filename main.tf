# ---------------------------------------------------------
# Resource Group
# ---------------------------------------------------------
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

# ---------------------------------------------------------
# Virtual Network + Subnet
# ---------------------------------------------------------
resource "azurerm_virtual_network" "main" {
  name                = "ctfd-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "main" {
  name                 = "ctfd-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

# ---------------------------------------------------------
# Public IP
# ---------------------------------------------------------
resource "azurerm_public_ip" "main" {
  name                = "ctfd-public-ip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# ---------------------------------------------------------
# Network Security Group
# ---------------------------------------------------------
resource "azurerm_network_security_group" "main" {
  name                = "ctfd-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTPS"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  ### BADDEL HEDHI KEN T7EB CUSTOM RANGE MTAA PORTS LCHALLENGE AAAAAAAA ###
  security_rule {
    name                       = "CTF-Challenge-Ports"
    priority                   = 2000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = var.challenge_port_range
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# ---------------------------------------------------------
# NIC
# ---------------------------------------------------------
resource "azurerm_network_interface" "main" {
  name                = "ctfd-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }
}

# ---------------------------------------------------------
# Network Watcher (make it destroyable)
# ---------------------------------------------------------
resource "azurerm_network_watcher" "main" {
  name                = "NetworkWatcher_${var.location}"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
}

# Attach NSG to NIC
resource "azurerm_network_interface_security_group_association" "main" {
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = azurerm_network_security_group.main.id
}

# ---------------------------------------------------------
# Virtual Machine (Ubuntu)
# ---------------------------------------------------------
# resource "azurerm_linux_virtual_machine" "main" {
#   name                = "ctfd-vm"
#   resource_group_name = azurerm_resource_group.main.name
#   location            = azurerm_resource_group.main.location
#   size                = var.vm_size
#   network_interface_ids = [
#     azurerm_network_interface.main.id
#   ]

#   admin_username = var.vm_admin_username

#   admin_ssh_key {
#     username   = var.vm_admin_username
#     public_key = var.ssh_public_key
#   }

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "0001-com-ubuntu-server-jammy"
#     sku       = "22_04-lts"
#     version   = "latest"
#   }
# }

resource "azurerm_linux_virtual_machine" "main" {
  name                = "ctfd-vm"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = var.vm_size
  network_interface_ids = [
    azurerm_network_interface.main.id
  ]

  admin_username = var.vm_admin_username
  admin_password = var.vm_admin_password # <-- add this

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = var.os_offer
    sku       = var.os_sku
    version   = "latest"
  }

  disable_password_authentication = false # <-- make sure password login is enabled

  # Use local cloud-init file to provision the VM on first boot
  custom_data = filebase64("${path.module}/cloud-init.yml")
}

