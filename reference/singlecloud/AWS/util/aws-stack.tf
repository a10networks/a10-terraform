variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  default = "10.0.2.0/24"
}

variable "amis" {
    type = "map"
    default = {
        "ap-northeast-1" = "ami-3b1e2f5c"
        "ap-northeast-2" = "ami-e0dc018e"
        "ap-southeast-1" = "ami-530eb430"
        "ap-southeast-2" = "ami-60d8d303"
        "eu-central-1"   = "ami-c24e91ad"
        "eu-west-1"      = "ami-1fbdb079"
        "sa-east-1"      = "ami-d58de1b9"
        "us-east-1"      = "ami-09721c1f"
        "us-east-2"      = "ami-3c183f59"
        "us-west-1"      = "ami-c46f49a4"
        "us-west-2"      = "ami-6bbd260b"
    }
}


variable "private_ip1" {
  default = "10.0.2.15"
}

variable "private_ip2" {
  default = "10.0.2.16"
}

variable "region"
{
  description = "AWS region"
  default = "eu-west-2"
}

variable "aws_key_name" {
  description = "AWS EC2 keypair"
  default = "terraform"
}

provider "aws" {
region = "${var.region}"
}

module "aws_compute" {
  source = "../../../../modules/AWS/infra/compute"
  network_interface_id = "${module.aws_network.default_network_interface_id}"
  region = "${var.region}"
  aws_key_name = "${var.aws_key_name}"
}

module "aws_network" {

  source = "../../../../modules/AWS/infra/network"
  vpc_cidr = "${var.vpc_cidr}"
  public_subnet_cidr = "${var.public_subnet_cidr}"
  private_subnet_cidr = "${var.private_subnet_cidr}"
  private_ip1 = "${var.private_ip1}"
  private_ip2 = "${var.private_ip2}"
  vthunder_instance_id = "${module.aws_compute.vthunder_instance_id}"
  region = "${var.region}"
}


output "vthunder id" { value = "${module.aws_compute.vthunder_instance_id}"}
output "public ip" { value = "${module.aws_compute.ip}"}
output "Default(1st) NIC" { value = "${module.aws_network.default_network_interface_id}"}
output "Elastic IP 1st" { value = "${module.aws_network.EIP1}"}
output "Elastic IP 2nd" { value = "${module.aws_network.EIP2}"}
output "Elastic IP 3rd" { value = "${module.aws_network.EIP3}"}
output "2nd NIC" { value = "${module.aws_network.new_network_interface_id}"}
