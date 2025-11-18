# ============================================
# CTFd Azure Deployment Configuration
# ============================================
# Copy this file to terraform.tfvars and fill in your values

# Required: Will prompt if not provided




location             = "switzerlandnorth"
resource_group_name  = "ctfd-rg"
#vm_admin_username    = "var.vm_admin_username"
vm_admin_username    = "firas"
#vm_admin_password    = "var.vm_admin_password"
vm_admin_password    = "Securinets123."
vm_size              = "Standard_B2s"
vm_count             = 1
challenge_port_range = "8000-8100"




# Optional: Uncomment to override defaults
# os_offer      = "0001-com-ubuntu-server-jammy"
# os_sku        = "22_04-lts"
# vnet_cidr     = "10.0.0.0/16"
# subnet_cidr   = "10.0.1.0/24"
# vnet_name     = "ctfd-vnet"
# subnet_name   = "ctfd-subnet"
# public_ip_name = "ctfd-ip"
# nic_name      = "ctfd-nic"
# vm_name       = "ctfd-vm"