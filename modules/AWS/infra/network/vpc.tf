provider "aws" {
    region = "${var.region}"
}


variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
    description = "CIDR for the Public Subnet"
    default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
    description = "CIDR for the Private Subnet"
    default = "10.0.2.0/24"
}

variable "private_ip1" {
  description = "private ip 1 of new aws_network_interface"
  default = "10.0.2.15"
}
variable "private_ip2" {
  description = "private ip 2 of new aws_network_interface"
  default = "10.0.2.16"
}

variable "vthunder_instance_id" {
  description = "compute instance id of vThunder"
}

variable "region" {
  description = "aws region"
}


resource "aws_vpc" "vpc01" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    tags {
        Name = "terraform-aws-vpc"
    }
}

resource "aws_internet_gateway" "default_gateway" {
    vpc_id = "${aws_vpc.vpc01.id}"
}

/*
  Public Subnet
*/
resource "aws_subnet" "subnet-public" {
    vpc_id = "${aws_vpc.vpc01.id}"

    cidr_block = "${var.public_subnet_cidr}"
    availability_zone = "${var.region}a"
    map_public_ip_on_launch= "true"

    tags {
        Name = "Public Subnet"
    }
}

resource "aws_route_table" "subnet-public" {
    vpc_id = "${aws_vpc.vpc01.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default_gateway.id}"
    }

    tags {
        Name = "Public Subnet"
    }
}

resource "aws_route_table_association" "subnet-public" {
    subnet_id = "${aws_subnet.subnet-public.id}"
    route_table_id = "${aws_route_table.subnet-public.id}"
}

/*
  Private Subnet
*/
resource "aws_subnet" "subnet-private" {
    vpc_id = "${aws_vpc.vpc01.id}"

    cidr_block = "${var.private_subnet_cidr}"
    availability_zone = "${var.region}a"

    tags {
        Name = "Private Subnet"
    }
}



resource "aws_security_group" "vThunder_sg" {
  name = "vThunder_sg"
  vpc_id = "${aws_vpc.vpc01.id}"


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  # Allow outgoing traffic to anywhere.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_network_interface" "default_network_interface" {
  subnet_id       = "${aws_subnet.subnet-public.id}"
  #private_ips     = ["10.0.1.15"]
  security_groups = ["${aws_security_group.vThunder_sg.id}"]
  tags {
    "TAG" = "default_network_interface"
  }
}


resource "aws_network_interface" "test" {
  #source = "../compute/"
  subnet_id       = "${aws_subnet.subnet-private.id}"
  private_ips     = ["${var.private_ip1}", "${var.private_ip2}"]
  security_groups = ["${aws_security_group.vThunder_sg.id}"]

  attachment {
    instance     = "${var.vthunder_instance_id}"
    device_index = 1
  }
}

resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = "${aws_network_interface.test.id}"
  associate_with_private_ip = "${var.private_ip1}"
}
resource "aws_eip" "two" {
  vpc                       = true
  network_interface         = "${aws_network_interface.test.id}"
  associate_with_private_ip = "${var.private_ip2}"

}

resource "aws_eip" "three" {
    vpc = true
}

resource "aws_eip_association" "eip_assoc" {
  network_interface_id   = "${aws_network_interface.default_network_interface.id}"
  allocation_id = "${aws_eip.three.id}"

}


output "default_network_interface_id" {value = "${aws_network_interface.default_network_interface.id}"}
output "EIP1" { value = "${aws_eip.one.public_ip}"}
output "EIP2" { value = "${aws_eip.two.public_ip}"}
output "EIP3" { value = "${aws_eip.three.public_ip}"}
output "new_network_interface_id" {value = "${aws_network_interface.test.id}"}
