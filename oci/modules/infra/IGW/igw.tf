variable "compartment_id" {
  description = "Compartment OCID"
}

variable "vcn_id" {
  description = "VCN ID"
}

resource "oci_core_internet_gateway" "a10_igw" {
  compartment_id = var.compartment_id
  vcn_id         = var.vcn_id
  display_name   = "a10-igw"
  enabled        = "true"
}

output "internet_gateway_id" { value = oci_core_internet_gateway.a10_igw.id }
