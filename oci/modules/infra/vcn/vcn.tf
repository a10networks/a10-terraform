
variable "compartment_id" {
  description = "Compartment OCID"
}

variable "vcn_cidr" {
  description = "VCN CIDR"
}

resource "oci_core_virtual_network" "a10_vcn" {
  compartment_id = var.compartment_id
  display_name   = "a10-vcn"
  cidr_block     = var.vcn_cidr
  dns_label      = "a10vcn"
}

output "id" { value = oci_core_virtual_network.a10_vcn.id }
output "default_dhcp_options_id" { value = oci_core_virtual_network.a10_vcn.default_dhcp_options_id }
