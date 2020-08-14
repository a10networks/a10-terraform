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
  name           = "tf_network_mgmt"
  admin_state_up = "true"
}

resource "openstack_networking_network_v2" "network_2" {
  name           = "tf_network_server"
  admin_state_up = "true"
}

resource "openstack_networking_network_v2" "network_3" {
  name           = "tf_network_client"
  admin_state_up = "true"
}


output "network_id_mgmt" { value = "${openstack_networking_network_v2.network_1.id}" }
output "network_id_server" { value = "${openstack_networking_network_v2.network_2.id}" }
output "network_id_client" { value = "${openstack_networking_network_v2.network_3.id}" }
