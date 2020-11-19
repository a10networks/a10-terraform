variable "compartment_id" {
  description = "Compartment OCID"
}

variable "vcn_id" {
  description = "VCN ID"
}

variable "internet_gateway_id" {
  description = "internet gateway ID"
}

resource "oci_core_route_table" "a10_rt" {
  compartment_id = var.compartment_id
  vcn_id         = var.vcn_id
  display_name   = "a10-rt"
  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = var.internet_gateway_id
  }
}

output "route_table_id" { value = oci_core_route_table.a10_rt.id }



