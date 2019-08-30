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

provider "openstack" {
 cloud = "openstack"
}


resource "openstack_networking_network_v2" "network_1" {
  name           = "tf_network"
  admin_state_up = "true"
}

resource "openstack_networking_network_v2" "network_2" {
  name           = "tf_network_default"
  admin_state_up = "true"
}


output "network_id" {value = "${openstack_networking_network_v2.network_1.id}" }

output "network_id_default" { value = "${openstack_networking_network_v2.network_2.id}"}
output "network_name" {value = "${openstack_networking_network_v2.network_1.name}" }
output "network_name_default" {value = "${openstack_networking_network_v2.network_2.name}" }
