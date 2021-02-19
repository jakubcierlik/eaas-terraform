terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.47.0"
    }
  }
}

provider "azurerm" {
  features {}
}


variable "azure_location_name" {
  type = string
  description = ""
}

variable "rg_name" {
  type = string
  description = ""
}

# variable "rg_tags" {
#   type = map(string)
#   description = ""
# }

variable "sg_name" {
  type = string
  description = ""
}

variable "vnet_name" {
  type = string
  description = ""
}

# variable "vnet_tags" {
#   type = map(string)
#   description = ""
# }

variable "cidr_block" {
  type = string
  description = ""
}

variable "subnet_1_name" {
  type = string
  description = ""
}

variable "subnet_1_cidr" {
  type = string
  description = ""
}

# variable "subnet_1_tags" {
#   type = map(string)
#   description = ""
# }

variable "subnet_2_name" {
  type = string
  description = ""
}

variable "subnet_2_cidr" {
  type = string
  description = ""
}

# variable "subnet_2_tags" {
#   type = map(string)
#   description = ""
# }

variable "sa_name" {
  type = string
  description = ""
}


resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.azure_location_name
#   tags = var.rg_tags
}

resource "azurerm_network_security_group" "sg" {
  name                = var.sg_name
  location            = var.azure_location_name
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "AllowSSH" {
  resource_group_name = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.sg.name
  access = "Allow"
  description = "SSH access"
  destination_address_prefix = "*"
  destination_port_range = 22
  direction = "Inbound"
  name = "AllowSSH"
  priority = 100
  protocol = "Tcp"
  source_address_prefix = "*"
  source_port_range = "*"
}

# resource "azurerm_network_security_rule" "AllowHTTP" {
#   resource_group_name = azurerm_resource_group.rg.name
#   network_security_group_name = azurerm_network_security_group.sg.name
#   access = "Allow"
#   description = "S3 access"
#   destination_address_prefix = "*"
#   destination_port_range = 80
#   direction = "Inbound"
#   name = "AllowHTTP"
#   priority = 101
#   protocol = "Tcp"
#   source_address_prefix = "*"
#   source_port_range = "*"
# }

# resource "azurerm_network_security_rule" "AllowHTTPS" {
#   resource_group_name = azurerm_resource_group.rg.name
#   network_security_group_name = azurerm_network_security_group.sg.name
#   access = "Allow"
#   description = "S3 access"
#   destination_address_prefix = "*"
#   destination_port_range = 443
#   direction = "Inbound"
#   name = "AllowHTTPS"
#   priority = 102
#   protocol = "Tcp"
#   source_address_prefix = "*"
#   source_port_range = "*"
# }

resource "azurerm_network_security_rule" "AllowS3" {
  resource_group_name = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.sg.name
  access = "Allow"
  description = "S3 access"
  destination_address_prefix = "*"
  destination_port_range = 9000
  direction = "Inbound"
  name = "AllowS3"
  priority = 103
  protocol = "Tcp"
  source_address_prefix = "*"
  source_port_range = "*"
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.azure_location_name
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = [var.cidr_block]

  subnet {
    name           = var.subnet_1_name
    address_prefix = var.subnet_1_cidr
  }

  subnet {
    name           = var.subnet_2_name
    address_prefix = var.subnet_2_cidr
  }

#   tags = var.vnet_tags
}

resource "azurerm_storage_account" "sa" {
  name                     = var.sa_name
  location                 = var.azure_location_name
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
