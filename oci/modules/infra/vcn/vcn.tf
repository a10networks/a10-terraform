
variable "compartment_id" {
  description = "Compartment OCID"
}

variable "vcn_name" {
  description = "VCN Name"
  default = "a10-vcn"
}

variable "vcn_cidrs" {
  description = "VCN CIDR"
}

resource "oci_core_virtual_network" "a10_vcn" {
  compartment_id = var.compartment_id
  display_name   = "${var.vcn_name}"
  cidr_blocks     = var.vcn_cidrs
  dns_label      = "a10vcn"
}

output "id" { value = oci_core_virtual_network.a10_vcn.id }
output "default_dhcp_options_id" { value = oci_core_virtual_network.a10_vcn.default_dhcp_options_id }
