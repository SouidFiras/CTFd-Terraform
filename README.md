

# Automated CTFd Hosting on Azure using Terraform

This project provides an **automated and low-effort way to deploy CTFd on Microsoft Azure** using **Terraform**.
It is designed mainly for **students** (especially those using **Azure Student subscriptions**) who want to host a CTF platform **quickly, cheaply, and reproducibly**.

The entire infrastructure (VM, networking, security rules, and CTFd setup) is handled automatically.

---

## What This Project Does

* Creates an **Azure Virtual Machine**
* Configures **networking and security rules**
* Automatically installs and runs **CTFd**
* Uses **Terraform** for reproducible infrastructure
* Requires **minimal manual configuration**

Once deployed, you will have a **ready-to-use CTFd instance** accessible via the VM’s public IP.

---

## Prerequisites

Before starting, make sure you have:

* An **Azure account** (Azure Student subscription works)
* A **Linux system** (or WSL on Windows)
* Basic knowledge of terminal usage

---

## Installation & Setup

### 1. Install Terraform

```bash
sudo apt update
sudo apt install terraform
```

---

### 2. Install Azure CLI

Either install using Microsoft’s script:

```bash
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

Or using apt:

```bash
sudo apt install azure-cli
```

---

### 3. Login to Azure

```bash
az login
```

This will open a browser window for authentication.

---

## Terraform Configuration

### 4. Initialize Terraform

Inside the project directory:

```bash
terraform init
```

This downloads the required providers and prepares Terraform.

---

### 5. Configure Variables

All required variables are located in:

```text
terraform.tfvars
```

You **must edit this file** and set the following required values:

* `vm_admin_username`: Admin username for the VM (e.g., `azureuser`, `ctfdadmin`)
* `vm_admin_password`: Admin password (must meet Azure complexity requirements)
* `location`: Azure region (e.g., `switzerlandnorth`, `francecentral`)
* `resource_group_name`: Name for your resource group (e.g., `ctfd-rg`)

Example:

```hcl
location             = "switzerlandnorth"
resource_group_name  = "ctfd-rg"
vm_admin_username    = "azureuser"
vm_admin_password    = "YourSecurePassword123!"
vm_size              = "Standard_B2s"
vm_count             = 1
challenge_port_range = "8000-8100"
```

You can also customize optional variables:

* `vm_size`: VM instance type (default: `Standard_B2s`)
* `vm_count`: Number of VMs to create (default: `1`)
* `challenge_port_range`: Port range for CTF challenges (default: `8000-8100`)

See `variables.tf` for all available options.

---

## Deployment

### 6. Deploy Infrastructure

Run:

```bash
terraform apply
```

Terraform will:

* Show a summary of what will be created
* Ask for confirmation

Type:

```text
yes
```

and wait for the deployment to finish.

---

## Accessing CTFd

After deployment:

* Terraform will output the **public IP address** of the VM
* Open your browser and go to:

```text
http://<VM_PUBLIC_IP>
```

CTFd should be running and accessible.

**To SSH into the VM:**

```bash
ssh <vm_admin_username>@<VM_PUBLIC_IP>
```

(Use the password you set in `terraform.tfvars` for `vm_admin_password`)

---

## Project Target Audience

This project is mainly intended for:

* **Students**
* **CTF organizers**
* **Cybersecurity clubs**
* Anyone wanting a **fast and reproducible CTFd deployment**

It was built with **Azure Student plans** in mind to keep costs minimal and setup simple.

---

## Cleanup (Important)

To avoid unnecessary charges, destroy the infrastructure when you’re done:

```bash
terraform destroy
```

---
