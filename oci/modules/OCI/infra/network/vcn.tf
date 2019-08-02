provider "oci" {
  version          = ">= 3.24.0"
  region           = "${var.region}"
  tenancy_ocid     = "${var.tenancy_ocid}"
  user_ocid        = "${var.user_ocid}"
  fingerprint	   = "${var.fingerprint}"
  private_key_path = "${var.private_key_path}"
  private_key_password = "${var.private_key_password}"
  }

variable "tenancy_ocid" {
description = "Tenancy OCID"
}

variable "user_ocid" {
description = "User OCID"
}

variable "compartment_id" {
description = "Compartment OCID"
default = "adas"
}

variable "region" {
description = "Region"
}
variable "private_key_path" {
description = "Private key file path"
}
variable "private_key_password" {
description = "Private Key Password"
}

variable "fingerprint" {
description = "fingerprint"
}

variable "vm_availability_domain" {
description = "VM availability domain"
}

variable "vm_display_name" {
description = "VM display name"
}

variable "vm_shape" {
description = "VM shape"
}

variable "vm_primary_vnic_display_name" {
description = "VM primary VNIC display name"
}


variable "vm_ssh_public_key_path" {
description = "VM ssh public key file path"
}

variable "vm_creation_timeout" {
description = "VM creation timeout"
}


variable "server_vnic_private_ip" {
description = "server VNIC private ip"
}

variable "server_vnic_display_name" {
description = "server VNIC display name"
}

variable "server_vnic_index" {
description = "server VNIC index"
}


variable "client_vnic_private_ip" {
description = "client VNIC private ip"
}

variable "client_vnic_display_name" {
description = "client VNIC display name"
}

variable "client_vnic_index" {
description = "client VNIC index"
}

# vcn.tf
resource "oci_core_virtual_network" "a10_vcn" {
  compartment_id = "${var.compartment_id}"
  display_name = "a10-vcn"
  cidr_block = "10.0.0.0/16"
  dns_label = "a10vcn"
}

resource "oci_core_internet_gateway" "a10_igw" {
  compartment_id = "${var.compartment_id}"
  vcn_id = "${oci_core_virtual_network.a10_vcn.id}"
  display_name = "a10-igw"
  enabled = "true"
}

resource "oci_core_route_table" "a10_rt" {
  compartment_id = "${var.compartment_id}"
  vcn_id = "${oci_core_virtual_network.a10_vcn.id}"
  display_name = "a10-rt"
  route_rules {
    destination = "0.0.0.0/0"
    network_entity_id = "${oci_core_internet_gateway.a10_igw.id}"
  }
}

resource "oci_core_security_list" "a10_sl" {
  compartment_id = "${var.compartment_id}"
  vcn_id = "${oci_core_virtual_network.a10_vcn.id}"
  display_name = "a10-sl"
  egress_security_rules = [
    { destination = "0.0.0.0/0" protocol = "all"}
  ]
  ingress_security_rules = [
    { protocol = "6", source = "0.0.0.0/0", tcp_options { "max" = 22, "min" = 22 }},
    { protocol = "6", source = "0.0.0.0/0", tcp_options { "max" = 80, "min" = 80 }},
    { protocol = "6", source = "0.0.0.0/0", tcp_options { "max" = 443, "min" = 443 }},
	{protocol = "6", source = "0.0.0.0/0", tcp_options { "max" = 8080, "min" = 8080 }},
  {protocol = "1", source = "0.0.0.0/0"}

  ]
}

resource "oci_core_subnet" "a10_subnet1" {
  compartment_id = "${var.compartment_id}"
  vcn_id = "${oci_core_virtual_network.a10_vcn.id}"
  display_name = "a10-subnet1"
  availability_domain = "${var.vm_availability_domain}"
  cidr_block = "10.0.1.0/24"
  route_table_id = "${oci_core_route_table.a10_rt.id}"
  security_list_ids = ["${oci_core_security_list.a10_sl.id}"]
  dhcp_options_id = "${oci_core_virtual_network.a10_vcn.default_dhcp_options_id}"
  dns_label = "a10subnet1"
}

resource "oci_core_subnet" "a10_subnet2" {
  compartment_id = "${var.compartment_id}"
  vcn_id = "${oci_core_virtual_network.a10_vcn.id}"
  display_name = "a10-subnet2"
  availability_domain = "${var.vm_availability_domain}"
  cidr_block = "10.0.2.0/24"
  route_table_id = "${oci_core_route_table.a10_rt.id}"
  security_list_ids = ["${oci_core_security_list.a10_sl.id}"]
  dhcp_options_id = "${oci_core_virtual_network.a10_vcn.default_dhcp_options_id}"
  dns_label = "a10subnet2"
}

resource "oci_core_subnet" "a10_subnet3" {
  compartment_id = "${var.compartment_id}"
  vcn_id = "${oci_core_virtual_network.a10_vcn.id}"
  display_name = "a10-subnet3"
  availability_domain = "${var.vm_availability_domain}"
  cidr_block = "10.0.3.0/24"
  route_table_id = "${oci_core_route_table.a10_rt.id}"
  security_list_ids = ["${oci_core_security_list.a10_sl.id}"]
  dhcp_options_id = "${oci_core_virtual_network.a10_vcn.default_dhcp_options_id}"
  dns_label = "a10subnet3"
}


output "oci_subnet_id1" { value = "${oci_core_subnet.a10_subnet1.id}" }
output "oci_subnet_id2" { value = "${oci_core_subnet.a10_subnet2.id}" }
output "oci_subnet_id3" { value = "${oci_core_subnet.a10_subnet3.id}" }
