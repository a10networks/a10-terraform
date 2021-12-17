variable "private_subnet_ids" {
  type = list
}

variable "public_subnet_ids" {
  type = list
}

variable "security_groups" {
  default = ""
}

variable "region" {
  description = "AWS Region"
  default     = ""
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

variable "count_vm" {
  default = "1"
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.region}"
}

#active NICs
resource "aws_network_interface" "active_default_NIC" {
  subnet_id       = "${element(var.public_subnet_ids, 0)}"
  security_groups = ["${var.security_groups}"]
  tags = {
    TAG = "${var.network_interface_name}"
  }
}

resource "aws_network_interface" "active_first" {
  subnet_id         = "${element(var.public_subnet_ids, 1)}"
  private_ips_count = "1"
  security_groups   = ["${var.security_groups}"]
  source_dest_check = "false"
}

resource "aws_network_interface" "active_second" {
  subnet_id       = "${element(var.private_subnet_ids, 0)}"
  security_groups = ["${var.security_groups}"]
  depends_on      = ["aws_network_interface.active_first"]
}


#standby NICs
resource "aws_network_interface" "stdby_default_NIC" {
  count           = "${var.count_vm - 1}"
  subnet_id       = "${element(var.public_subnet_ids, 0)}"
  security_groups = ["${var.security_groups}"]
  tags = {
    TAG = "${var.network_interface_name}"
  }
}

resource "aws_network_interface" "stdby_first" {
  count             = "${var.count_vm - 1}"
  subnet_id         = "${element(var.public_subnet_ids, 1)}"
  private_ips_count = "1"
  security_groups   = ["${var.security_groups}"]
  source_dest_check = "false"
}

resource "aws_network_interface" "stdby_second" {
  count           = "${var.count_vm - 1}"
  subnet_id       = "${element(var.private_subnet_ids, 0)}"
  security_groups = ["${var.security_groups}"]
  depends_on      = ["aws_network_interface.stdby_first"]
}

output "active_default_network_interface_id" { value = "${aws_network_interface.active_default_NIC.*.id}" }
output "active_first_network_interface_id" { value = "${aws_network_interface.active_first.*.id}" }
output "active_second_network_interface_id" { value = "${aws_network_interface.active_second.*.id}" }


output "stdby_default_network_interface_id" { value = "${aws_network_interface.stdby_default_NIC.*.id}" }
output "stdby_first_network_interface_id" { value = "${aws_network_interface.stdby_first.*.id}" }
output "stdby_second_network_interface_id" { value = "${aws_network_interface.stdby_second.*.id}" }

output "active_first_private_ips" { value = "${aws_network_interface.active_first.*.private_ips}" }
output "stdby_first_private_ips" { value = "${aws_network_interface.stdby_first.*.private_ips}" }

#output "eth1_second_private_ip"{value = "${element(aws_network_interface.active_first.*.private_ips, 1)}"}
#output "eth2_private_ip"{value = "${element(aws_network_interface.active_second.*.private_ips, 0)}"}
#output "eth1_sec_private_ip"{value = "${element(aws_network_interface.active_first.*.private_ips, 0)}"}
