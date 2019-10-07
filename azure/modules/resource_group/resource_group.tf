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


provider "azurerm" {
    subscription_id = "${var.subscription_id}"
    client_id       = "${var.client_id}"
    client_secret   = "${var.client_secret}"
    tenant_id       = "${var.client_id}"
}

# Create a resource group if it doesn’t exist
resource "azurerm_resource_group" "terraformgroup" {
    name     = "Terraform-ResourceGroup"
    location = "${var.location}"

    tags = {
        environment = "Terraform"
    }
}


output "resource_group_name" {value = "${azurerm_resource_group.terraformgroup.name}"}
