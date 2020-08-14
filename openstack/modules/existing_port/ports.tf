

variable "instance_id" {
  default = ""
}

variable "mgmt_subnet_id" {
  default = ""
}

variable "eth1_subnet_id" {
  default = ""
}

variable "eth2_subnet_id" {
  default = ""
}

variable "mgmt_network_id" {
  default = ""
}

variable "eth1_network_id" {
  default = ""
}

variable "eth2_network_id" {
  default = ""
}

provider "openstack" {
  cloud = "openstack"
}


resource "openstack_networking_port_v2" "port_1" {
  name       = "vthunder_port1"
  network_id = "${var.eth1_network_id}"
  fixed_ip = {
    subnet_id = "${var.eth1_subnet_id}"
  }
  admin_state_up        = "true"
  port_security_enabled = "false"
}
/*

resource "openstack_networking_port_v2" "port_2" {
  name               = "vthunder_port2"
  network_id         = "${var.eth2_network_id}"
  fixed_ip = {
      subnet_id = "${var.eth2_subnet_id}"
    }
  admin_state_up     = "true"
  port_security_enabled = "false"
}
*/
resource "openstack_networking_port_v2" "extra" {
  name       = "vthunder_extra"
  network_id = "${var.eth1_network_id}"
  fixed_ip = {
    subnet_id = "${var.eth1_subnet_id}"
  }
  admin_state_up        = "true"
  port_security_enabled = "false"
}

resource "openstack_compute_interface_attach_v2" "ai_1" {
  instance_id = "${var.instance_id}"
  port_id     = "${openstack_networking_port_v2.port_1.id}"
}
/*
resource "openstack_compute_interface_attach_v2" "ai_2" {
  instance_id = "${var.instance_id}"
  port_id     = "${openstack_networking_port_v2.port_2.id}"
}
*/
output "port1" { value = "${openstack_networking_port_v2.port_1.id}" }
#output "port2" {value = "${openstack_networking_port_v2.port_2.id}"}
output "extra_port" { value = "${openstack_networking_port_v2.extra.id}" }
