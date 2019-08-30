variable "network_id" {
}

provider "openstack" {
  cloud = "openstack"
}

variable "cidr" {
type = "list"
}

variable "network_id_default" {
  default = ""
}


resource "openstack_networking_subnet_v2" "subnet" {
  count = 3
  name       = "subnet${count.index}"
  network_id = "${var.network_id}"
  cidr       = "${element(var.cidr, count.index)}"
  ip_version = 4
}

resource "openstack_networking_subnet_v2" "subnet2" {
  name       = "subnet${count.index}"
  network_id = "${var.network_id_default}"
  cidr       = "10.0.1.0/24"
  ip_version = 4
}



output "subnet_ids" {value = "${openstack_networking_subnet_v2.subnet.*.id}"}
output "default_subnet" {value = "${openstack_networking_subnet_v2.subnet2.id}"}
