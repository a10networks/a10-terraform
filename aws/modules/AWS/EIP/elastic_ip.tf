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

variable "count_ip" {
  default = "1"
}
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.region}"
}

variable "active_default_network_interface_id" {
  type = list
}

variable "active_first_network_interface_id" {
  type = list
}
variable "active_first_private_ips" {
  type = list
}

variable "stdby_default_network_interface_id" {
  type = list
}

variable "stdby_first_network_interface_id" {
  type = list
}
variable "stdby_first_private_ips" {
  type = list
}

resource "null_resource" "before" {
  triggers = {
    instance_check1 = "${element(var.active_first_network_interface_id, 0)}"
  }
}

resource "null_resource" "delay" {
  provisioner "local-exec" {
    command = "sleep 60"
  }
  depends_on = ["null_resource.before"]
}

resource "null_resource" "after" {
  depends_on = ["null_resource.delay"]
}

#active EIP
resource "aws_eip" "active_eip_one" {
  vpc               = true
  network_interface = "${element(var.active_default_network_interface_id, 0)}"
  depends_on        = ["null_resource.after"]
  #associate_with_private_ip = "${element(var.private_ip, 0) }"
}

resource "aws_eip" "active_eip_two" {
  vpc = true
  #network_interface         = "${element(var.new_network_interface_id, count.index)}"
  network_interface         = "${element(var.active_first_network_interface_id, 0)}"
  associate_with_private_ip = "${element(var.active_first_private_ips, 0)}"
  depends_on                = ["aws_eip.active_eip_one"]
}
/*
resource "aws_eip" "active_eip_three" {
  vpc                       = true
  #network_interface         = "${element(var.new_network_interface_id, count.index)}"
  network_interface = "${element(var.first_network_interface_id,count.index)}"
  associate_with_private_ip = "${element(var.active_first_private_ips, 0)}"
}
*/



#stdby EIP
resource "aws_eip" "stdby_eip_one" {
  count             = "${length(var.stdby_default_network_interface_id)}"
  vpc               = true
  network_interface = "${element(var.stdby_default_network_interface_id, count.index)}"
  depends_on        = ["aws_eip.active_eip_two"]
  #associate_with_private_ip = "${element(var.private_ip, count.index) }"
}

resource "aws_eip" "stdby_eip_two" {
  #count = "${var.count - 1 }"
  count = "${length(var.stdby_first_network_interface_id)}"
  vpc   = true
  #network_interface         = "${element(var.new_network_interface_id, count.index)}"
  network_interface = "${element(var.stdby_first_network_interface_id, count.index)}"
  //associate_with_private_ip = "${element(var.stdby_first_private_ips, count.index)}"
  associate_with_private_ip = "${element(tolist(var.stdby_first_private_ips[count.index]), 0)}"
  depends_on                = ["aws_eip.stdby_eip_one"]
}

/*
resource "aws_eip" "stdby_eip_three" {
  #count = "${var.count - 1 }"
  count = "1"
  vpc                       = true
  #network_interface         = "${element(var.new_network_interface_id, count.index)}"
  network_interface = "${element(var.first_network_interface_id,count.index)}"
  associate_with_private_ip = "${element(var.private_ip_NIC, (count.index + 1))}"
}
*/
