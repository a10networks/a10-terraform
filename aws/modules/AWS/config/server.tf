variable "vthunder_mgmt_ip" {
  type = "list"
}

variable "password" {
  type = "list"
}

variable "backend_server_ip" {
  default = ""
}

variable "virtual_server_ip" {
  type = "string"
}

variable "eth1_second_private_ip" {
  type = "string"
}

variable "eth2_private_ip" {
  type = "string"
}


variable "region" {
  description = "AWS Region"
  default     = ""
}

variable "aws_access_key" {
  default = ""
}
variable "aws_secret_key" {
  default = ""
}


provider "vthunder" {
  username = "admin"
  address  = "${element(var.vthunder_mgmt_ip, 0)}"
  password = "${element(var.password, 0)}"
}

resource "vthunder_server" "rs9" {
  health_check_disable = 1
  name                 = "rs9"
  host                 = "${var.backend_server_ip}"
  port_list {
    health_check_disable = 1
    port_number          = 80
    protocol             = "tcp"
  }
}

resource "vthunder_service_group" "sg9" {
  name     = "sg9"
  protocol = "TCP"
  member_list {
    name = "${vthunder_server.rs9.name}"
    port = 80
  }
}

resource "vthunder_virtual_server" "vs9" {
  name       = "vs9"
  ha_dynamic = 1
  ip_address = "${var.virtual_server_ip}"
  port_list {
    auto          = 1
    port_number   = 8080
    protocol      = "tcp"
    service_group = "${vthunder_service_group.sg9.name}"
    snat_on_vip   = 1
  }
}

resource "vthunder_rib_route" "rib" {
  ip_dest_addr = "0.0.0.0"
  ip_mask      = "/0"
  ip_nexthop_ipv4 {
    ip_next_hop         = "${element(split(".", var.eth1_second_private_ip), 0)}.${element(split(".", var.eth1_second_private_ip), 1)}.${element(split(".", var.eth1_second_private_ip), 2)}.1"
    distance_nexthop_ip = 1
  }
}

resource "vthunder_ethernet" "eth" {
  ethernet_list {
    ifnum = 1
    ip {
      #dhcp=1
      address_list = {
        ipv4_address = "${var.eth1_second_private_ip}"
        ipv4_netmask = "255.255.255.0"
      }
    }
    action = "enable"
  }
  ethernet_list {
    ifnum = 2
    ip {
      #dhcp=1
      address_list = {
        ipv4_address = "${var.eth2_private_ip}"
        ipv4_netmask = "255.255.255.0"
      }
    }
    action = "enable"
  }
}
