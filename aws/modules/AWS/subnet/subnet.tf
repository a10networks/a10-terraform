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

provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.region}"
}

variable "CIDR_range" {
type = "list"
}

variable "subnet_count" {
  default = "1"
}
variable "public_ip_on_launch" {
  default = "false"
}

variable "vpc_id" {
  default = ""
}


variable "count_vm" {
  default = "1"
}

resource "aws_subnet" "public" {
    count = "2"
    vpc_id = "${var.vpc_id}"
    cidr_block = "${element(var.CIDR_range,count.index)}"
    availability_zone = "${var.region}a"
    map_public_ip_on_launch= "true"
    tags = {
        Name = "public subnet"
    }
}

resource "aws_subnet" "private" {
    count = "${var.count_vm - 2 }"
    vpc_id = "${var.vpc_id}"
    cidr_block = "${element(var.CIDR_range,(count.index + 2))}"
    availability_zone = "${var.region}a"
    map_public_ip_on_launch= "false"
    tags = {
        Name = "private subnet"
    }
}

#output "new_subnet_id" {value = "aws_subnet.${var.subnet_name}.public_ip"}
output "private_subnet_id" { value = "${aws_subnet.private.*.id}"}
output "public_subnet_id" { value = "${aws_subnet.public.*.id}"}
