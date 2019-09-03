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

variable "network_id" {
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
  network_id = "${module.VPC.network_id}"
  network_id_default = "${module.VPC.network_id_default}"
}

module "router" {
  source = "../../../../modules/Routing"
  external_network_id = "${var.external_network_id}"
  subnet_id = "${module.subnet.subnet_ids}"
  default_subnet = "${module.subnet.default_subnet}"
}

module "compute" {
  source = "../../../../modules/compute"
  image_id = "${var.image_id}"
  flavor_name = "${var.flavor_name}"
  sg_id = "${module.security_group.security_group_id}"
  network_name = "${module.VPC.network_name_default}"

}


module "security_group" {
  source = "../../../../modules/security_group"

}

module "port" {
  source = "../../../../modules/port"
  sg_id = "${module.security_group.security_group_id}"
  network_id = "${module.VPC.network_id}"
  subnet_ids = "${module.subnet.subnet_ids}"
  network_id_default = "${module.VPC.network_id}"
  instance_id = "${module.compute.instance_id}"
}


module "floating_ip" {
  source = "../../../../modules/floating_ip"
  port1 = "${module.port.port1}"
  port2 = "${module.port.port2}"
  extra_port = "${module.port.extra_port}"
  instance_id = "${module.compute.instance_id}"
}
