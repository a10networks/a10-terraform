variable "username" {
}

variable "tenant_name" {
}

variable "auth_url" {
}

variable "region" {
}

variable "tenant_id" {
  default = ""
}

variable "sg_id" {
  default = ""
}

variable "flavor_name" {
  default = ""
}

variable "image_id" {
  default = ""
}


variable "mgmt_network_name" {
  default = ""
}

variable "eth1_network_name" {
  default = ""
}

variable "eth2_network_name" {
  default = ""
}

variable "eth1_network_id" {
  default = ""
}

variable "eth2_network_id" {
  default = ""
}

variable "mgmt_network_id" {
  default = ""
}

variable "network_id" {
  default = ""
}

variable "mgmt_subnet_id" {
  default = ""
}

variable "eth1_subnet_id" {
  default = ""
}

variable "eth2_subnet_id" {
  default = ""
}

/*
module "VPC" {
  source = "../../../modules/VPC"
  username = "${var.username}"
  tenant_name = "${var.tenant_name}"
  tenant_id = "${var.tenant_id}"
  password = "${var.password}"
  auth_url = "${var.auth_url}"
  region = "${var.region}"
}
*/
module "compute" {
  source = "../../../../modules/compute"
  image_id = "${var.image_id}"
  flavor_name = "${var.flavor_name}"
  mgmt_network_name = "${var.mgmt_network_name}"
  eth1_network_name = "${var.eth1_network_name}"
  eth2_network_name = "${var.eth2_network_name}"
  #port1 = "${module.port.port1}"
}


module "port" {
  source = "../../../../modules/existing_port"
  mgmt_network_id = "${var.mgmt_network_id}"
  eth1_network_id = "${var.eth1_network_id}"
  eth2_network_id = "${var.eth2_network_id}"
  instance_id = "${module.compute.instance_id}"
  mgmt_subnet_id = "${var.mgmt_subnet_id}"
  eth1_subnet_id = "${var.eth1_subnet_id}"
  eth2_subnet_id = "${var.eth2_subnet_id}"

}


module "floating_ip" {
  source = "../../../../modules/floating_ip"
  port1 = "${module.port.port1}"
  #port2 = "${module.port.port2}"
  extra_port = "${module.port.extra_port}"
  instance_id = "${module.compute.instance_id}"
}

output "mgmt_ip" { value = "${module.floating_ip.mgmt_ip}"}
output "vvip_ip" { value = "${module.floating_ip.vvip_ip}"}
output "app_server_ip" {value = "${module.compute.app_server_ip}"}
