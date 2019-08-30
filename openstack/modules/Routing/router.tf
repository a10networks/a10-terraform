provider "openstack" {
  cloud = "openstack"
}

variable "external_network_id" {
}

variable "subnet_id" {
type="list"
}

variable "default_subnet" {
}

resource "openstack_networking_router_v2" "router_1" {
  name                = "tf_router"
  admin_state_up      = true
  external_network_id = "${var.external_network_id}"
}


resource "openstack_networking_router_v2" "router_2" {
  name                = "tf_router"
  admin_state_up      = true
  external_network_id = "${var.external_network_id}"
}



resource "openstack_networking_router_interface_v2" "router_interface_1" {
  count = 3
  router_id = "${openstack_networking_router_v2.router_1.id}"
  subnet_id = "${element(var.subnet_id,count.index)}"
}

resource "openstack_networking_router_interface_v2" "router_interface_2" {
  router_id = "${openstack_networking_router_v2.router_2.id}"
  subnet_id = "${var.default_subnet}"
}

output "router_id" {value = "${openstack_networking_router_v2.router_1.id}"}
