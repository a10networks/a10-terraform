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

variable "cidr" {
type="list"
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

variable "network_name" {
  default = ""
}

variable "external_network_id" {
}



module "VPC" {
  source = "../../../../modules/VPC"
  username = "${var.username}"
  tenant_name = "${var.tenant_name}"
  tenant_id = "${var.tenant_id}"
  auth_url = "${var.auth_url}"
  region = "${var.region}"
}

module "subnet" {
  source = "../../../../modules/subnet"
  cidr = "${var.cidr}"
  network_id_mgmt = "${module.VPC.network_id_mgmt}"
  network_id_server = "${module.VPC.network_id_server}"
  network_id_client = "${module.VPC.network_id_client}"
}

module "router" {
  source = "../../../../modules/Routing"
  external_network_id = "${var.external_network_id}"
  subnet_id_mgmt = "${module.subnet.subnet_id_mgmt}"
  subnet_id_server = "${module.subnet.subnet_id_server}"
  subnet_id_client = "${module.subnet.subnet_id_client}"
}


module "compute" {
  source = "../../../../modules/new_compute"
  image_id = "${var.image_id}"
  flavor_name = "${var.flavor_name}"
  network_id_mgmt = "${module.VPC.network_id_mgmt}"
  network_id_server = "${module.VPC.network_id_server}"
  network_id_client = "${module.VPC.network_id_client}"
  #port1 = "${module.port.port1}"
}

/*
module "security_group" {
  source = "../../../../modules/security_group"

}
*/

module "port" {
  source = "../../../../modules/port"
  network_id_mgmt = "${module.VPC.network_id_mgmt}"
  network_id_server = "${module.VPC.network_id_server}"
  network_id_client = "${module.VPC.network_id_client}"
  subnet_id_mgmt = "${module.subnet.subnet_id_mgmt}"
  subnet_id_server = "${module.subnet.subnet_id_server}"
  subnet_id_client = "${module.subnet.subnet_id_client}"
  instance_id = "${module.compute.instance_id}"
}


module "floating_ip" {
  source = "../../../../modules/floating_ip"
  port1 = "${module.port.port_client}"
  extra_port = "${module.port.extra_port}"
  instance_id = "${module.compute.instance_id}"
}


output "vvip_ip" {value = "${module.floating_ip.vvip_ip}"}
output "mgmt_ip" {value = "${module.floating_ip.mgmt_ip}"}
output "app_server_ip" {value = "${module.compute.app_server_ip}"}
