variable "subnet_id" {
  type = "list"
}

variable "vthunder_instance_id" {
  type = "list"
}

variable "security_groups" {
  default = ""
}

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

variable "network_interface_name" {
  default = "network_interface_default"
}

variable "count" {
  default = "1"
}

variable "countnic" {
  default = "4"
}

variable "vm_count" {
  default = ""
}

variable "nic_first" {
  default = "1"
}

provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.region}"
}

variable "public_subnet_id" {
type = "list"}


resource "aws_network_interface" "first" {
  count = "1"
  subnet_id = "${element(var.public_subnet_id, (count.index + 1))}"
  private_ips_count     = "1"
  security_groups = ["${var.security_groups}"]
  source_dest_check = "false"
}

resource "aws_network_interface" "second" {
  count = "1"
  subnet_id = "${element(var.subnet_id, (count.index + 1))}"
  security_groups = ["${var.security_groups}"]
  depends_on = ["aws_network_interface.first"]
}

resource "aws_network_interface" "third" {
  count = "1"
  subnet_id = "${element(var.subnet_id, (count.index + 1))}"
  security_groups = ["${var.security_groups}"]
}

resource "aws_network_interface" "default_NIC" {
  count = "${var.vm_count}"
  subnet_id       = "${element(var.public_subnet_id, count.index)}"
  security_groups = ["${var.security_groups}"]
  tags {
    "TAG" = "${var.network_interface_name}"
  }
}

output "default_network_interface_id" {value = "${aws_network_interface.default_NIC.*.id}"}
output "first_network_interface_id" {value = "${aws_network_interface.first.*.id}"}
output "second_network_interface_id" {value = "${aws_network_interface.second.*.id}"}
output "third_network_interface_id" {value = "${aws_network_interface.third.*.id}"}

output "private_ip_NIC" {value = "${aws_network_interface.first.private_ips}"}

output "eth1_second_private_ip" {value = "${element(aws_network_interface.first.private_ips, 1)}"}

output "eth2_private_ip" {value = "${element(aws_network_interface.second.private_ips, 0)}"}

output "eth1_sec_private_ip" {value = "${element(aws_network_interface.first.private_ips, 0)}"}
