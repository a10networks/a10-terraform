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

variable "count_ip" {
  default = "1"
}
provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.region}"
}

variable "default_network_interface_id" {
type = "list"
}

variable "private_ip_NIC" {
type = "list"
}

variable "first_network_interface_id" {
type = "list"
}

resource "aws_eip" "one" {
  count = "1"
  vpc                       = true
  network_interface         = "${element(var.default_network_interface_id, count.index)}"
  #associate_with_private_ip = "${element(var.private_ip, count.index) }"
}

resource "aws_eip" "two" {
  #count = "${var.count - 1 }"
  count = "1"
  vpc                       = true
  #network_interface         = "${element(var.new_network_interface_id, count.index)}"
  network_interface = "${element(var.first_network_interface_id,count.index)}"
  associate_with_private_ip = "${element(var.private_ip_NIC, count.index)}"
  depends_on = ["aws_eip.one"]
}

resource "aws_eip" "three" {
  #count = "${var.count - 1 }"
  count = "1"
  vpc                       = true
  #network_interface         = "${element(var.new_network_interface_id, count.index)}"
  network_interface = "${element(var.first_network_interface_id,count.index)}"
  associate_with_private_ip = "${element(var.private_ip_NIC, (count.index + 1))}"
}



#output "EIP" { value = "aws_eip.create_eip"}
