variable "network_id_mgmt" {
  default = ""
}

variable "network_id_server" {
  default = ""
}

variable "network_id_client" {
  default = ""
}

variable "subnet_id_mgmt" {
}

variable "subnet_id_server" {
  default = ""
}

variable "subnet_id_client" {
  default = ""
}

variable "instance_id" {
  default = ""
}


provider "openstack" {
  cloud = "openstack"
}

resource "openstack_networking_port_v2" "port_1" {
  name       = "vthunder_client_port"
  network_id = "${var.network_id_client}"

  fixed_ip = {
    subnet_id = "${var.subnet_id_client}"
  }
  port_security_enabled = "false"
  admin_state_up        = "true"
  #security_group_ids = ["${var.sg_id}"]

}

resource "openstack_networking_port_v2" "extra" {
  name       = "vthunder_extra_port"
  network_id = "${var.network_id_server}"

  fixed_ip = {
    subnet_id = "${var.subnet_id_server}"
  }
  port_security_enabled = "false"
  admin_state_up        = "true"
  #security_group_ids = ["${var.sg_id}"]
  depends_on = ["openstack_networking_port_v2.port_1"]
}


resource "openstack_compute_interface_attach_v2" "ai_1" {
  instance_id = "${var.instance_id}"
  port_id     = "${openstack_networking_port_v2.port_1.id}"
  depends_on  = ["openstack_networking_port_v2.extra"]
}


output "port_client" { value = "${openstack_networking_port_v2.port_1.id}" }
output "extra_port" { value = "${openstack_networking_port_v2.extra.id}" }
