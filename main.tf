# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }

  required_version = ">= 0.14.9"
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

# Random String Resource
resource "random_string" "myrandom" {
  length = 6
  upper = false 
  special = false   
}

# Create Virtual Network
resource "azurerm_virtual_network" "myvnet" {
  name                = "myvnet-1"
  address_space       = ["10.0.0.0/16"]
  location            = "Central US"
  resource_group_name = "1-901e0083-playground-sandbox"
  tags = {
    Environment = "TheBatCave"
    Team        = "Cave"
  }
}

# Create Subnet
resource "azurerm_subnet" "mysubnet" {
  name                 = "mysubnet-1"
  resource_group_name  = "1-901e0083-playground-sandbox"
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Create Public IP Address
resource "azurerm_public_ip" "mypublicip" {
  name                = "mypublicip-1"
  resource_group_name = "1-901e0083-playground-sandbox"
  location            = "Central US"
  allocation_method   = "Static"
  domain_name_label = "app1-vm-${random_string.myrandom.id}"
  tags = {
    environment = "Dev"
  }
}

# Create Network Interface
resource "azurerm_network_interface" "myvmnic" {
  name                = "vmnic"
  location            = "Central US"
  resource_group_name = "1-901e0083-playground-sandbox"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mysubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.mypublicip.id 
  }
}

