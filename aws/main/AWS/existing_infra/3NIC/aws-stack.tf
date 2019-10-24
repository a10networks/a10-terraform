variable "vthunder_address" {
  default = ""
}

variable "password" {
  default = ""
}

variable "aws_access_key" {
  default = ""
}

variable "aws_secret_key" {
  default = ""
}

variable "subnet_count" {
  default = "1"
}

variable "count" {
  default = "1"
}

variable "subnet_name" {
  default = ""
}

variable "vpc_id" {
  default = ""
}

variable "public_subnet_id" {
  type="list"
}

variable "private_subnet_id" {
  type="list"
}

variable "security_groups" {
  default=""
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
    "sa-east-1"      = "ami-e96e2085"
    "us-east-1"      = "ami-09721c1f"
    "us-east-2"      = "ami-3c183f59"
    "us-west-1"      = "ami-c46f49a4"
    "us-west-2"      = "ami-6bbd260b"
  }
}

variable "region" {
  description = "AWS region"
}

variable "aws_key_name" {
  description = "AWS EC2 keypair"
}


variable "countnic" {
  default = ""
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.region}"
}

module "aws_compute" {
  aws_access_key       = "${var.aws_access_key}"
  aws_secret_key       = "${var.aws_secret_key}"
  region               = "${var.region}"
  source               = "../../../../modules/AWS/compute"
  #nic_list = "${concat("module.NIC.default_network_interface_id","module.add_NIC.new_network_interface_id")}"
  aws_key_name         = "${var.aws_key_name}"
  count                = "${var.count}"
  default_nic_id = "${module.add_NIC.default_network_interface_id}"
  first_network_interface_id = "${module.add_NIC.first_network_interface_id}"
  second_network_interface_id = "${module.add_NIC.second_network_interface_id}"
  third_network_interface_id = "${module.add_NIC.third_network_interface_id}"
}

module "add_NIC" {
  vm_count = "${var.count}"
  countnic          = "${var.subnet_count - 1 }"
  source         = "../../../../modules/AWS/add_NIC"
  aws_access_key = "${var.aws_access_key}"
  aws_secret_key = "${var.aws_secret_key}"
  region         = "${var.region}"
  subnet_id      = "${var.private_subnet_id}"
  public_subnet_id = "${var.public_subnet_id}"
  security_groups = "${var.security_groups}"
  vthunder_instance_id = "${module.aws_compute.vthunder_instance_id}"
}

module "EIP1" {
  count = "${var.subnet_count}"
  source = "../../../../modules/AWS/EIP"
  aws_access_key = "${var.aws_access_key}"
  aws_secret_key = "${var.aws_secret_key}"
  region = "${var.region}"
  default_network_interface_id = "${module.add_NIC.default_network_interface_id}"
  first_network_interface_id = "${module.add_NIC.first_network_interface_id}"
  private_ip_NIC = "${module.add_NIC.private_ip_NIC}"
  #aws_eip_name = "${var.aws_eip_name}"
}

output "vthunder IP(s)" {value = "${module.aws_compute.vthunder_instance_id}"}
output "Default NIC ID" {value = "${module.add_NIC.default_network_interface_id}"}
output "vThuder management IP " { value = "${module.aws_compute.ip}"}
output "Instance id " { value = "${module.aws_compute.vthunder_instance_id}"}
