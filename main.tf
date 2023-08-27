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
    Environment = "Dev"
    Team        = "DevSecOps-Team"
  }
}

# Create Subnet
resource "azurerm_subnet" "mysubnet" {
  name                 = "mysubnet-1"
  resource_group_name  = "1-901e0083-playground-sandbox"
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

