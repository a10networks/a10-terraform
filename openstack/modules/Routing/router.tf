provider "openstack" {
  cloud = "openstack"
}

variable "external_network_id" {
}

variable "subnet_id_mgmt" {
  default = ""
}

variable "subnet_id_client" {
  default = ""
}
variable "subnet_id_server" {
  default = ""
}

resource "openstack_networking_router_v2" "router_1" {
  name                = "tf_router_mgmt"
  admin_state_up      = true
  external_network_id = "${var.external_network_id}"
}


resource "openstack_networking_router_v2" "router_2" {
  name                = "tf_router_server"
  admin_state_up      = true
  external_network_id = "${var.external_network_id}"
}

resource "openstack_networking_router_v2" "router_3" {
  name                = "tf_router_client"
  admin_state_up      = true
  external_network_id = "${var.external_network_id}"
}



resource "openstack_networking_router_interface_v2" "router_interface_1" {
  router_id = "${openstack_networking_router_v2.router_1.id}"
  subnet_id = "${var.subnet_id_mgmt}"
}

resource "openstack_networking_router_interface_v2" "router_interface_2" {
  router_id = "${openstack_networking_router_v2.router_2.id}"
  subnet_id = "${var.subnet_id_server}"
}

resource "openstack_networking_router_interface_v2" "router_interface_3" {
  router_id = "${openstack_networking_router_v2.router_3.id}"
  subnet_id = "${var.subnet_id_client}"
}

output "router_id_mgmt" { value = "${openstack_networking_router_v2.router_1.id}" }
output "router_id_server" { value = "${openstack_networking_router_v2.router_2.id}" }
output "router_id_client" { value = "${openstack_networking_router_v2.router_3.id}" }
