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

variable "vpc_id" {
  default = ""
}

provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.region}"
}


resource "aws_internet_gateway" "default_gateway" {
    vpc_id = "${var.vpc_id}"
}

output "igw_id" { value = "${aws_internet_gateway.default_gateway.id}" }
