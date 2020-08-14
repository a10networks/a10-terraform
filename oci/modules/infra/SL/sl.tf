
variable "compartment_id" {
  description = "Compartment OCID"
}

variable "vcn_id" {
  description = "VCN ID"
}

resource "oci_core_security_list" "a10_sl" {
  compartment_id = "${var.compartment_id}"
  vcn_id         = "${var.vcn_id}"
  display_name   = "a10-sl"
  /*egress_security_rules = [
    { 
    destination = "0.0.0.0/0"
    protocol = "all"}
  ]
  ingress_security_rules = [
    { protocol = "6", source = "0.0.0.0/0", tcp_options = { "max" = 22, "min" = 22 }},
    { protocol = "6", source = "0.0.0.0/0", tcp_options = { "max" = 80, "min" = 80 }},
    { protocol = "6", source = "0.0.0.0/0", tcp_options = { "max" = 443, "min" = 443 }},
	{protocol = "6", source = "0.0.0.0/0", tcp_options = { "max" = 8080, "min" = 8080 }},
  {protocol = "1", source = "0.0.0.0/0"}
  ]*/
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      max = 22
      min = 22
    }
  }
  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      max = 80
      min = 80
    }
  }
  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      max = 443
      min = 443
    }
  }
  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      max = 8080
      min = 8080
    }
  }
  ingress_security_rules {
    protocol = "1"
    source   = "0.0.0.0/0"
  }

}

output "security_list_ids" { value = "${oci_core_security_list.a10_sl.id}" }

