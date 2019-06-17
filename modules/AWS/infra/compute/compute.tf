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
        "sa-east-1"      = "ami-d58de1b9"
        "us-east-1"      = "ami-09721c1f"
        "us-east-2"      = "ami-3c183f59"
        "us-west-1"      = "ami-c46f49a4"
        "us-west-2"      = "ami-6bbd260b"
    }
}
variable "network_interface_id" {
    description = "NIC Id"
}

provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.region}"
}

resource "aws_instance" "centos-vm01" {
  #ami           = "ami-090cbf775708a1421"
  ami ="${lookup(var.amis,var.region)}"
  instance_type = "m4.xlarge"
  #subnet_id = "${aws_subnet.us-east-2a-public.id}"
  #vpc_security_group_ids = ["${aws_security_group.test_sg.id}"]
  #key_name = "${aws_key_pair.ec2key.key_name}"
  network_interface {
    #network_interface_id       = "${aws_network_interface.default.id}"
network_interface_id = "${var.network_interface_id}"
     device_index               = 0
    }
  key_name = "${var.aws_key_name}"
 tags {
  Name = "vThunder-vm01"
 }
}


output "ip" {
  value = "${aws_instance.centos-vm01.public_ip}"

}

output "vthunder_instance_id" {
  value = "${aws_instance.centos-vm01.id}"
}
