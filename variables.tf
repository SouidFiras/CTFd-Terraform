###############
# LOCATIONS
###############
variable "location" {
  description = <<EOT
Choose an Azure region to deploy resources:
- eastus
- eastus2
- westeurope
- northeurope
- uksouth
- ukwest
- centralus
- southcentralus
- francecentral
- germanywestcentral
- switzerlandwest
- switzerlandnorth
EOT

  type = string

  validation {
    condition = contains([
      "eastus", "eastus2",
      "westeurope", "northeurope",
      "uksouth", "ukwest",
      "centralus", "southcentralus",
      "francecentral", "germanywestcentral",
      "switzerlandnorth", "switzerlandwest"
    ], var.location)

    error_message = "Invalid location. Choose a valid Azure region from the list."
  }
}

###############
# RESOURCE GROUP
###############
variable "resource_group_name" {
  description = "Name of the Azure Resource Group."
  type        = string
}

###############
# VM SETTINGS
###############
variable "vm_admin_username" {
  description = "Admin username for the VM."
  type        = string
}

variable "vm_admin_password" {
  description = "Password for the VM admin user. Must meet Azure complexity requirements."
  type        = string
  sensitive   = true
}

variable "vm_size" {
  description = <<EOT
Choose an Azure VM size. Available options:

Burstable:
- Standard_B1s  : 1 vCPU, 1 GiB RAM
- Standard_B2s  : 2 vCPU, 4 GiB RAM
- Standard_B2ms : 2 vCPU, 8 GiB RAM
- Standard_B4ms : 4 vCPU, 16 GiB RAM
- Standard_B8ms : 8 vCPU, 32 GiB RAM

General Purpose (Ds-series):
- Standard_D2s_v3 : 2 vCPU, 8 GiB RAM
- Standard_D4s_v3 : 4 vCPU, 16 GiB RAM
- Standard_D8s_v3 : 8 vCPU, 32 GiB RAM

Memory Optimized (E-series):
- Standard_E2s_v3 : 2 vCPU, 16 GiB RAM
- Standard_E4s_v3 : 4 vCPU, 32 GiB RAM
EOT

  type = string

  validation {
    condition = contains([
      "Standard_B1s", "Standard_B2s", "Standard_B2ms", "Standard_B4ms", "Standard_B8ms",
      "Standard_D2s_v3", "Standard_D4s_v3", "Standard_D8s_v3",
      "Standard_E2s_v3", "Standard_E4s_v3"
    ], var.vm_size)

    error_message = "Invalid VM size. Please choose a valid Azure VM SKU from the list."
  }
}

variable "vm_count" {
  description = "Number of VMs to create."
  type        = number

  validation {
    condition     = var.vm_count >= 1 && var.vm_count <= 20
    error_message = "vm_count must be between 1 and 20."
  }
}

variable "challenge_port_range" {
  description = "Destination port range for CTF challenges (e.g., 8000-8100)"
  type        = string
}

###############
# OPTIONAL - WITH DEFAULTS (won't prompt)
###############
variable "os_offer" {
  description = "Ubuntu offer (image type)."
  type        = string
  default     = "0001-com-ubuntu-server-jammy"

  validation {
    condition = contains([
      "0001-com-ubuntu-server-jammy",
      "0001-com-ubuntu-server-focal",
      "0001-com-ubuntu-server-jammy-gen2",
      "0001-com-ubuntu-server-focal-gen2"
    ], var.os_offer)

    error_message = "Invalid Ubuntu offer."
  }
}

variable "os_sku" {
  description = "Ubuntu SKU version."
  type        = string
  default     = "22_04-lts"

  validation {
    condition = contains([
      "22_04-lts",
      "20_04-lts"
    ], var.os_sku)

    error_message = "Invalid SKU. Choose 22_04-lts or 20_04-lts."
  }
}

variable "vnet_cidr" {
  description = "Address space for VNet."
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "Address prefix for Subnet."
  type        = string
  default     = "10.0.1.0/24"
}

variable "vnet_name" {
  description = "Virtual network name"
  type        = string
  default     = "ctfd-vnet"
}

variable "subnet_name" {
  description = "Subnet name"
  type        = string
  default     = "ctfd-subnet"
}

variable "public_ip_name" {
  description = "Public IP name"
  type        = string
  default     = "ctfd-ip"
}

variable "nic_name" {
  description = "Network interface name"
  type        = string
  default     = "ctfd-nic"
}

variable "vm_name" {
  description = "Virtual machine name"
  type        = string
  default     = "ctfd-vm"
}