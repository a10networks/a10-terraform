variable "region" {
    description = "AWS Region"
    default = ""
}

variable "aws_access_key" {
  default = ""
}
variable "aws_secret_key" {
  default = ""
}

variable "security_grp" {
  default = ""
}

variable "device_index" {
  default = ""
}

provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.region}"
}

variable "network_interface_name" {
  default = "network_interface_default"
}

variable "subnet_id" {
  type = "list"
}

variable "vthunder_instance_id" {
  default = ""
}


resource "aws_network_interface" "NIC" {
  subnet_id       = "${element(var.subnet_id,count.index)}"
  #private_ips     = ["10.0.1.15"]
  security_groups = ["${var.security_grp}"]
  tags {
    "TAG" = "${var.network_interface_name}"
  }
}

output "default_network_interface_id" {value = "${aws_network_interface.NIC.*.id}"}
