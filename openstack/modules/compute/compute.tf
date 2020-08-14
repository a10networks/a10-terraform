


variable "image_id" {
}

variable "flavor_name" {
}

variable "username" {
  default = ""
}

variable "tenant_name" {
  default = ""
}

variable "auth_url" {
  default = ""
}

variable "region" {
  default = ""
}

variable "tenant_id" {
  default = ""
}

variable "mgmt_network_name" {
  default = ""
}

variable "eth1_network_name" {
  default = ""
}

variable "eth2_network_name" {
  default = ""
}

variable "centos_image_id" {
  default = "786217ea-4c34-476e-b7a0-b38d16aba6d6"
}
provider "openstack" {
  cloud = "openstack"
}

resource "openstack_compute_instance_v2" "TF-VM" {
  name        = "TF-Vthunder-vm01-test"
  image_id    = "${var.image_id}"
  flavor_name = "${var.flavor_name}"
  #security_groups = ["${var.sg_id}"]



  network {
    name = "${var.mgmt_network_name}"
  }

  network {
    name = "${var.eth2_network_name}"
  }

}

resource "openstack_compute_instance_v2" "app" {
  name        = "tf-app-server01"
  image_id    = "${var.centos_image_id}"
  flavor_name = "m1.medium"
  #security_groups = ["${var.sg_id}"]


  network {
    name = "${var.eth2_network_name}"
  }

  user_data = "${file("user_data.sh")}"

}

output "instance_id" { value = "${openstack_compute_instance_v2.TF-VM.id}" }
output "app_server_ip" { value = "${openstack_compute_instance_v2.app.access_ip_v4}" }
