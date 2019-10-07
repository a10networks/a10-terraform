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

variable "public_id3" {
}

variable "public_id2" {
}

variable "public_id1" {
}

variable "security_group_id" {
}

variable "mgmt_subnet_id" {
}

variable "server_subnet_id" {
}

variable "client_subnet_id" {
}

variable "private_subnet_id" {
  default = ""
}

provider "azurerm" {
    subscription_id = "${var.subscription_id}"
    client_id       = "${var.client_id}"
    client_secret   = "${var.client_secret}"
    tenant_id       = "${var.client_id}"
}

# Create network interface

resource "azurerm_network_interface" "mgmt_nic" {
    name                      = "mgmt_nic"
    location                  = "${var.location}"
    resource_group_name       = "${var.resource_group_name}"
    network_security_group_id = "${var.security_group_id}"

    ip_configuration {
        name                          = "NicConfiguration"
        subnet_id                     = "${var.mgmt_subnet_id}"
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = "${var.public_id1}"
    }

    tags = {
        environment = "mgmt-tf-nic"
    }
}
resource "azurerm_network_interface" "server_nic" {
    name                      = "server_nic"
    location                  = "${var.location}"
    resource_group_name       = "${var.resource_group_name}"
    network_security_group_id = "${var.security_group_id}"

    ip_configuration {
        name                          = "NicConfiguration"
        subnet_id                     = "${var.server_subnet_id}"
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = "${var.public_id2}"
    }

    tags = {
        environment = "server-tf-nic"
    }
    depends_on = ["azurerm_network_interface.mgmt_nic"]
}

resource "azurerm_network_interface" "client_nic" {
    name                      = "client_nic"
    location                  = "${var.location}"
    resource_group_name       = "${var.resource_group_name}"
    network_security_group_id = "${var.security_group_id}"

    ip_configuration {
        name                          = "NicConfiguration"
        subnet_id                     = "${var.client_subnet_id}"
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = "${var.public_id3}"
    }

    tags = {
        environment = "client-tf-nic"
    }
    depends_on = ["azurerm_network_interface.server_nic"]

}

output "mgmt_nic" { value = "${azurerm_network_interface.mgmt_nic.id}" }
output "server_nic" { value = "${azurerm_network_interface.server_nic.id}" }
output "client_nic" { value = "${azurerm_network_interface.client_nic.id}" }
