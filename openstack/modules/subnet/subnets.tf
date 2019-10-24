variable "cidr" {
type = "list"
}

variable "network_id_mgmt" {
}

variable "network_id_server" {
}

variable "network_id_client" {
}

provider "openstack" {
  cloud = "openstack"
}



resource "openstack_networking_subnet_v2" "subnet1" {
  name       = "mgmt_subnet"
  network_id = "${var.network_id_mgmt}"
  cidr       = "${element(var.cidr, 1)}"
  ip_version = 4
}

resource "openstack_networking_subnet_v2" "subnet2" {
  name       = "server_subnet"
  network_id = "${var.network_id_server}"
  cidr       = "${element(var.cidr, 2)}"
  ip_version = 4
  depends_on = ["openstack_networking_subnet_v2.subnet1"]
}

resource "openstack_networking_subnet_v2" "subnet3" {
  name       = "client_subnet"
  network_id = "${var.network_id_client}"
  cidr       = "${element(var.cidr, 3)}"
  ip_version = 4
}





output "subnet_id_mgmt" {value = "${openstack_networking_subnet_v2.subnet1.id}"}
output "subnet_id_server" {value = "${openstack_networking_subnet_v2.subnet2.id}"}
output "subnet_id_client" {value = "${openstack_networking_subnet_v2.subnet3.id}"}
