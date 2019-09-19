

variable "tenant_id" {
}

variable "subscription_id" {
}

variable "client_id" {
}

variable "client_secret" {
}

variable "subnet_cidr" {
}

variable "resource_group_name" {
}

variable "virtual_network_name" {
}

provider "azurerm" {
    subscription_id = "${var.subscription_id}"
    client_id       = "${var.client_id}"
    client_secret   = "${var.client_secret}"
    tenant_id       = "${var.client_id}"
}

# Create subnet
resource "azurerm_subnet" "mgmt_subnet" {
    name                 = "mgmt_subnet"
    resource_group_name  = "${var.resource_group_name}"
    virtual_network_name = "${var.virtual_network_name}"
    address_prefix       = "${var.subnet_cidr}"
}


output "subnet_id" {value = "${azurerm_subnet.mgmt_subnet.id}"}
