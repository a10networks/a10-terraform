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

variable "network_name" {
  default = ""
}

variable "network_id" {
  default = ""
}

variable "subnet_ids" {
type = "list"
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
  network_name = "${var.network_name}"
  port1 = "${module.port.port1}"
}

module "port" {
  source = "../../../../modules/existing_port"
  network_id = "${var.network_id}"
  instance_id = "${module.compute.instance_id}"
  subnet_ids = "${var.subnet_ids}"
}

module "floating_ip" {
  source = "../../../../modules/floating_ip"
  port1 = "${module.port.port1}"
  port2 = "${module.port.port2}"
  extra_port = "${module.port.extra_port}"
  instance_id = "${module.compute.instance_id}"
}
