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

variable "default_nic_id" {
type = "list"
}


provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.region}"
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

variable "first_network_interface_id"{
type = "list"
}

variable "second_network_interface_id"{
type = "list"
}


variable "third_network_interface_id"{
type = "list"
}

resource "aws_instance" "vThunder"{
  ami ="${lookup(var.amis,var.region)}"
  instance_type = "m4.xlarge"
  network_interface{
      network_interface_id = "${element(var.default_nic_id,0)}"
      device_index               = "0"
    }

  #  subnet = "${var.env == "production" ? var.prod_subnet : var.dev_subnet}"

  network_interface {
    network_interface_id = "${element(var.first_network_interface_id, 0)}"
    device_index = "1"
  }
  network_interface {
    network_interface_id = "${element(var.second_network_interface_id, 0)}"
    device_index = "2"
  }
  availability_zone = "${var.region}a"

  key_name = "${var.aws_key_name}"

  tags = {
      #Name = "bh_vThunder-vm${count.index}"
      Name = "vthunder-a10-demo"
    }
  }
  /*resource "null_resource" "test1"{

    provisioner "local-exec" {
      command = <<EOT

        ansible-playbook playbook.yml --extra-vars "a10_host='${aws_instance.vThunder.public_ip}' a10_password='${aws_instance.vThunder.id}' slb_server_host='10.0.0.1' slb_service_group_member='10.0.0.1' slb_vritual_server_ip='10.0.0.3' "
  EOT
    }
    depends_on = ["aws_instance.vThunder"]
  }*/

  output "vthunder_instance_id"{
    value = "${aws_instance.vThunder.*.id}"
    }
  output "ip"{
    value = "${aws_instance.vThunder.*.public_ip}"
    }
  output "private_ip"{
    value = "${aws_instance.vThunder.*.private_ip}"
    }
