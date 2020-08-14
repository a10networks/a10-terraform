

variable "tenant_id" {
}

variable "subscription_id" {
}

variable "client_id" {
}

variable "client_secret" {
}

variable "location" {
}

variable "virtual_network_cidr" {
}

variable "resource_group_name" {
}

provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.client_id}"
}

# Create virtual network
resource "azurerm_virtual_network" "terraformnetwork" {
  name                = "terraform-Vnet"
  address_space       = ["${var.virtual_network_cidr}"]
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  tags = {
    environment = "Terraform"
  }
}

output "virtual_network_name" { value = "${azurerm_virtual_network.terraformnetwork.name}" }
