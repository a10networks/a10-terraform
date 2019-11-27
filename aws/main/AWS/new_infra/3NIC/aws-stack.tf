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

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet_count" {
  default = "1"
}

variable "count_vm" {
  default = "1"
}

variable "subnet_name" {
  default = ""
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

variable "subnet_cidr" {
  type = "list"
}

variable "countnic" {
  default = ""
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.region}"
}

module "vpc" {
  source         = "../../../../modules/AWS/VPC"
  aws_access_key = "${var.aws_access_key}"
  aws_secret_key = "${var.aws_secret_key}"
  region         = "${var.region}"
  vpc_cidr       = "${var.vpc_cidr}"
}

module "subnet" {
  source              = "../../../../modules/AWS/subnet"
  aws_access_key      = "${var.aws_access_key}"
  aws_secret_key      = "${var.aws_secret_key}"
  region              = "${var.region}"
  #subnet_name        = "${var.subnet_name}"
  count_vm            = "${var.count_vm}"  #private_subnet_name = "${var.subnet_name}"
  CIDR_range          = "${var.subnet_cidr}"
  public_ip_on_launch = "true"
  vpc_id              = "${module.vpc.vpc_id}"
  subnet_count        = "${var.subnet_count}"
}

module "IGW" {
  source         = "../../../../modules/AWS/IGW"
  aws_access_key = "${var.aws_access_key}"
  aws_secret_key = "${var.aws_secret_key}"
  region         = "${var.region}"
  vpc_id         = "${module.vpc.vpc_id}"
}

module "route_table" {
  source         = "../../../../modules/AWS/Routing"
  aws_access_key = "${var.aws_access_key}"
  aws_secret_key = "${var.aws_secret_key}"
  region         = "${var.region}"
  igw_id         = "${module.IGW.igw_id}"
  subnet_id      = "${module.subnet.public_subnet_ids}"
  vpc_id         = "${module.vpc.vpc_id}"
}


module "aws_compute" {
  aws_access_key       = "${var.aws_access_key}"
  aws_secret_key       = "${var.aws_secret_key}"
  region               = "${var.region}"
  source               = "../../../../modules/AWS/compute"
  #nic_list = "${concat("module.NIC.default_network_interface_id","module.add_NIC.new_network_interface_id")}"
  aws_key_name         = "${var.aws_key_name}"
  count_vm                = "${var.count_vm}"
  active_default_nic_id = "${module.add_NIC.active_default_network_interface_id}"
  active_first_network_interface_id = "${module.add_NIC.active_first_network_interface_id}"
  active_second_network_interface_id = "${module.add_NIC.active_second_network_interface_id}"
  stdby_default_nic_id = "${module.add_NIC.stdby_default_network_interface_id}"
  stdby_first_network_interface_id = "${module.add_NIC.stdby_first_network_interface_id}"
  stdby_second_network_interface_id = "${module.add_NIC.stdby_second_network_interface_id}"

}

#change naming for SG
module "SG" {
  source         = "../../../../modules/AWS/security_group"
  aws_access_key = "${var.aws_access_key}"
  aws_secret_key = "${var.aws_secret_key}"
  region         = "${var.region}"
  vpc_id         = "${module.vpc.vpc_id}"
}

module "add_NIC" {
  count_vm = "${var.count_vm}"
  source         = "../../../../modules/AWS/add_NIC"
  aws_access_key = "${var.aws_access_key}"
  aws_secret_key = "${var.aws_secret_key}"
  region         = "${var.region}"
  private_subnet_ids      = "${module.subnet.private_subnet_ids}"
  public_subnet_ids = "${module.subnet.public_subnet_ids}"
  security_groups = "${module.SG.security_grp}"
}

module "EIP" {
  count_ip = "${var.subnet_count}"
  source = "../../../../modules/AWS/EIP"
  aws_access_key = "${var.aws_access_key}"
  aws_secret_key = "${var.aws_secret_key}"
  region = "${var.region}"
  active_default_network_interface_id = "${module.add_NIC.active_default_network_interface_id}"
  active_first_network_interface_id = "${module.add_NIC.active_first_network_interface_id}"
  active_first_private_ips = "${element(module.add_NIC.active_first_private_ips,0)}"
  stdby_default_network_interface_id = "${module.add_NIC.stdby_default_network_interface_id}"
  stdby_first_network_interface_id = "${module.add_NIC.stdby_first_network_interface_id}"
  stdby_first_private_ips = "${element(module.add_NIC.stdby_first_private_ips,0)}"

  
}

output "VPC_ID" { value = "${module.vpc.vpc_id}"}
output "Public_subnet" {value = "${module.subnet.public_subnet_ids}"}
output "Private_Subnets" {value = "${module.subnet.private_subnet_ids}"}

output "vThuder_management_IP" { value = "${module.aws_compute.ip_active}"}

output "active_instance_id" { value = "${module.aws_compute.instance_id_active}"}

output "stdby_instance_list" { value = "${module.aws_compute.stdby_instance_list}"}
