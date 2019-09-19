variable "tenant_id" {
}

variable "subscription_id" {
}

variable "client_id" {
}

variable "client_secret" {
}

variable "resource_group_name" {
}

variable "location" {
}

provider "azurerm" {
    subscription_id = "${var.subscription_id}"
    client_id       = "${var.client_id}"
    client_secret   = "${var.client_secret}"
    tenant_id       = "${var.client_id}"
}


# Create public IPs
resource "azurerm_public_ip" "terraformpublicip" {
    name                         = "PublicIP1"
    location                     = "${var.location}"
    resource_group_name          = "${var.resource_group_name}"
    allocation_method            = "Dynamic"

    tags = {
        environment = "Terraform"
    }
}

resource "azurerm_public_ip" "terraformpublicip2" {
    name                         = "PublicIP2"
    location                     = "${var.location}"
    resource_group_name          = "${var.resource_group_name}"
    allocation_method            = "Dynamic"

    tags = {
        environment = "Terraform"
    }
}

resource "azurerm_public_ip" "terraformpublicip3" {
    name                         = "PublicIP3"
    location                     = "${var.location}"
    resource_group_name          = "${var.resource_group_name}"
    allocation_method            = "Dynamic"

    tags = {
        environment = "Terraform"
    }
}

output "public_ip1" { value = "${azurerm_public_ip.terraformpublicip.id}"}
output "public_ip2" { value = "${azurerm_public_ip.terraformpublicip2.id}"}
output "public_ip3" { value = "${azurerm_public_ip.terraformpublicip3.id}"}
