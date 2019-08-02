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

variable "igw_id" {
  default = ""
}

variable "vpc_id" {
  default = ""
}

variable "subnet_id" {
  type = "list"
}

provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.region}"
}

resource "aws_route_table" "subnet-public" {
    vpc_id = "${var.vpc_id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${var.igw_id}"
    }

    tags {
        Name = "Public Subnet"
    }
}

resource "aws_route_table_association" "subnet-public" {
    count = 2
    subnet_id = "${element(var.subnet_id,count.index)}"
    route_table_id = "${aws_route_table.subnet-public.id}"
}
