
variable "compartment_id" {
description = "Compartment OCID"
}

variable "vcn_id" {
description = "VCN ID"
}

variable "route_table_id"{
description = "Route table id"
}

variable "security_list_ids"{
type="list"
description = "Security List ids"
}

variable "vm_availability_domain" {
description = "VM availability domain"
}

variable "default_dhcp_options_id"{
description  = "default dhcp options id"
}

<<<<<<< HEAD
variable "subnet_cidr"{
type = "list"
description  = "subnet CIDR range"
}

=======
>>>>>>> 0c0f5adebe9a3d7bd8eeeb07581f184dd8545b46
resource "oci_core_subnet" "a10_subnet1" {
  compartment_id = "${var.compartment_id}"
  vcn_id = "${var.vcn_id}"
  display_name = "a10-subnet1"
  availability_domain = "${var.vm_availability_domain}"
<<<<<<< HEAD
  cidr_block = "${element(var.subnet_cidr, 0)}"
=======
  cidr_block = "10.0.1.0/24"
>>>>>>> 0c0f5adebe9a3d7bd8eeeb07581f184dd8545b46
  route_table_id = "${var.route_table_id}"
  security_list_ids = ["${var.security_list_ids}"]
  dhcp_options_id = "${var.default_dhcp_options_id}"
  dns_label = "a10subnet1"
}

resource "oci_core_subnet" "a10_subnet2" {
  compartment_id = "${var.compartment_id}"
  vcn_id = "${var.vcn_id}"
  display_name = "a10-subnet2"
  availability_domain = "${var.vm_availability_domain}"
<<<<<<< HEAD
  cidr_block =  "${element(var.subnet_cidr, 1)}"
=======
  cidr_block = "10.0.2.0/24"
>>>>>>> 0c0f5adebe9a3d7bd8eeeb07581f184dd8545b46
  route_table_id = "${var.route_table_id}"
  security_list_ids = ["${var.security_list_ids}"]
  dhcp_options_id = "${var.default_dhcp_options_id}"
  dns_label = "a10subnet2"
}

resource "oci_core_subnet" "a10_subnet3" {
  compartment_id = "${var.compartment_id}"
  vcn_id = "${var.vcn_id}"
  display_name = "a10-subnet3"
  availability_domain = "${var.vm_availability_domain}"
<<<<<<< HEAD
  cidr_block =  "${element(var.subnet_cidr, 2)}"
=======
  cidr_block = "10.0.3.0/24"
>>>>>>> 0c0f5adebe9a3d7bd8eeeb07581f184dd8545b46
  route_table_id = "${var.route_table_id}"
  security_list_ids = ["${var.security_list_ids}"]
  dhcp_options_id = "${var.default_dhcp_options_id}"
  dns_label = "a10subnet3"
}


output "oci_subnet_id1" { value = "${oci_core_subnet.a10_subnet1.id}" }
output "oci_subnet_id2" { value = "${oci_core_subnet.a10_subnet2.id}" }
output "oci_subnet_id3" { value = "${oci_core_subnet.a10_subnet3.id}" }
<<<<<<< HEAD
=======

>>>>>>> 0c0f5adebe9a3d7bd8eeeb07581f184dd8545b46
