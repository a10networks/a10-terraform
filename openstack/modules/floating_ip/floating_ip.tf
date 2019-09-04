

variable "port1" {
}
/*
variable "port2" {
}
*/
variable "extra_port" {
}

variable "instance_id" {
  default = ""
}

provider "openstack" {
 cloud = "openstack"
}


resource "openstack_networking_floatingip_v2" "floatip_1" {
  pool = "public"
}

resource "openstack_networking_floatingip_v2" "floatip_2" {
  pool = "public"
}

resource "openstack_networking_floatingip_v2" "floatip_3" {
  pool = "public"
}


resource "openstack_compute_floatingip_associate_v2" "fip_1" {
  floating_ip = "${openstack_networking_floatingip_v2.floatip_1.address}"
  instance_id = "${var.instance_id}"
}

resource "openstack_networking_floatingip_associate_v2" "fip_2" {
  floating_ip = "${openstack_networking_floatingip_v2.floatip_2.address}"
  port_id     = "${var.port1}"
}


resource "openstack_networking_floatingip_associate_v2" "fip_3" {
  floating_ip = "${openstack_networking_floatingip_v2.floatip_3.address}"
  port_id     = "${var.extra_port}"
}


output "mgmt_ip" { value = "${openstack_networking_floatingip_v2.floatip_1.address}"}
output "vvip_ip" { value = "${openstack_networking_floatingip_v2.floatip_3.address}"}
