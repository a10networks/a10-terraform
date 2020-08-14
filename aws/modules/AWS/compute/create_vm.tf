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

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.region}"
}

variable "aws_key_name" {
  description = "AWS EC2 keypair"
}

variable "amis" {
  type = "map"
  default = {
    "ap-northeast-1" = "ami-3b1e2f5c"
    "ap-northeast-2" = "ami-e0dc018e"
    "ap-southeast-1" = "ami-530eb430"
    "ap-southeast-2" = "ami-60d8d303"
    "eu-central-1"   = "ami-c24e91ad"
    "eu-west-2"      = "ami-c2987da5"
    "sa-east-1"      = "ami-e96e2085"
    "us-east-1"      = "ami-09721c1f"
    "us-east-2"      = "ami-3c183f59"
    "us-west-1"      = "ami-c46f49a4"
    "us-west-2"      = "ami-6bbd260b"
  }
}


variable "count_vm" {
  default = "1"
}


variable "active_default_nic_id" {
  type = "list"
}


variable "active_first_network_interface_id" {
  type = "list"
}

variable "active_second_network_interface_id" {
  type = "list"
}


variable "stdby_default_nic_id" {
  type = "list"
}


variable "stdby_first_network_interface_id" {
  type = "list"
}

variable "stdby_second_network_interface_id" {
  type = "list"
}

#active VT
resource "aws_instance" "active_vThunder" {
  ami           = "${lookup(var.amis, var.region)}"
  instance_type = "m4.xlarge"
  network_interface {
    network_interface_id = "${element(var.active_default_nic_id, 0)}"
    device_index         = "0"
  }

  network_interface {
    network_interface_id = "${element(var.active_first_network_interface_id, 0)}"
    device_index         = "1"
  }
  network_interface {
    network_interface_id = "${element(var.active_second_network_interface_id, 0)}"
    device_index         = "2"
  }
  availability_zone = "${var.region}a"

  key_name = "${var.aws_key_name}"

  tags = {
    Name = "vthunder-a10-demo"
  }
}

#stdby
resource "aws_instance" "stdby_vThunder" {

  count = "${var.count_vm - 1}"

  ami           = "${lookup(var.amis, var.region)}"
  instance_type = "m4.xlarge"
  network_interface {
    network_interface_id = "${element(var.stdby_default_nic_id, count.index)}"
    device_index         = "0"
  }

  network_interface {
    network_interface_id = "${element(var.stdby_first_network_interface_id, count.index)}"
    device_index         = "1"
  }
  network_interface {
    network_interface_id = "${element(var.stdby_second_network_interface_id, count.index)}"
    device_index         = "2"
  }
  availability_zone = "${var.region}a"

  key_name = "${var.aws_key_name}"

  tags = {
    Name = "vthunder-a10-demo"
  }
}

#smita changes
output "ip_active" { value = "${element(aws_instance.active_vThunder.*.public_ip, 0)}" }
output "instance_id_active" { value = "${element(aws_instance.active_vThunder.*.id, 0)}" }

output "stdby_ip_list" { value = "${aws_instance.stdby_vThunder.*.public_ip}" }
output "stdby_instance_list" { value = "${aws_instance.stdby_vThunder.*.id}" }

