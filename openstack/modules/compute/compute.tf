


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

variable "network_name" {
  default = ""
}

variable "sg_id" {
  default = ""
}

variable "port1" {
  default = ""
}

provider "openstack" {
  cloud = "openstack"
}

resource "openstack_compute_instance_v2" "TF-VM" {
  name      = "TF-Vthunder-vm01-test"
  image_id  = "${var.image_id}"
  flavor_name = "${var.flavor_name}"
  #security_groups = ["${var.sg_id}"]


  network {
    name = "${var.network_name}"
  }

}

output "instance_id" { value = "${openstack_compute_instance_v2.TF-VM.id}" }
