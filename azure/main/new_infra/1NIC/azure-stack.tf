variable "tenant_id" {
}

variable "subscription_id" {
}

variable "client_id" {
}

variable "client_secret" {
}

variable "virtual_network_cidr" {
}

variable "location" {
}

variable "subnet_cidr" {
}

provider "azurerm" {
    subscription_id = "${var.subscription_id}"
    client_id       = "${var.client_id}"
    client_secret   = "${var.client_secret}"
    tenant_id       = "${var.client_id}"
}

module "resource_group" {
  source = "../../../modules/resource_group"
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.client_id}"
  location        = "${var.location}"
}

module "virtual_network" {
  source = "../../../modules/virtual_network"
  virtual_network_cidr = "${var.virtual_network_cidr}"
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.client_id}"
  resource_group_name = "${module.resource_group.resource_group_name}"
  location        = "${var.location}"
}

module "subnet" {
  source = "../../../modules/subnet"
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.client_id}"
  resource_group_name = "${module.resource_group.resource_group_name}"
  virtual_network_name = "${module.virtual_network.virtual_network_name}"
  subnet_cidr = "${var.subnet_cidr}"

}


module "security_group" {
  source = "../../../modules/security_groups"
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.client_id}"
  resource_group_name = "${module.resource_group.resource_group_name}"
  location        = "${var.location}"
}

module "nic" {
  source = "../../../modules/network_interface"
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.client_id}"
  location        = "${var.location}"
  resource_group_name = "${module.resource_group.resource_group_name}"
  security_group_id = "${module.security_group.sg_id}"
  public_id1 = "${module.public_ip.public_ip1}"
  public_id2 = "${module.public_ip.public_ip2}"
  public_id3 = "${module.public_ip.public_ip3}"
  server_subnet_id = "${module.subnet.subnet_id}"
  client_subnet_id = "${module.subnet.subnet_id}"
  mgmt_subnet_id = "${module.subnet.subnet_id}"

}

module "compute" {
  source = "../../../modules/compute"
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.client_id}"
  location        = "${var.location}"
  resource_group_name = "${module.resource_group.resource_group_name}"
  mgmt_nic_id = "${module.nic.mgmt_nic}"
  server_nic_id = "${module.nic.server_nic}"
  client_nic_id = "${module.nic.mgmt_nic}"

}

module "public_ip" {
  source = "../../../modules/public_ip"
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.client_id}"
  location        = "${var.location}"
  resource_group_name = "${module.resource_group.resource_group_name}"
}
