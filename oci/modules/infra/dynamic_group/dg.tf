variable "compartment_id" {
  description = "Compartment OCID"
}

variable "tenancy_ocid" {
  description = "Tenancy OCID"
}

variable "instance_list" {
  type        = list(string)
  description = "instance list"
}

variable "dynamic_group_name" {
  default = "vrrp-dynamic-group"
}

variable "policy_name" {
  default = "vrrp-dynamic-group-policy"
}


resource "oci_identity_dynamic_group" "dynamic_group" {
  compartment_id = var.tenancy_ocid
  description    = "Dynamic group for vThunders launched by tf"
  matching_rule  = "ANY { ${join(", ", formatlist("instance.id = %s", var.instance_list))} }"
  name           = var.dynamic_group_name

}

resource "oci_identity_policy" "dynamic_group_policy" {
  #Required
  depends_on = [
    oci_identity_dynamic_group.dynamic_group,
  ]
  compartment_id = var.tenancy_ocid
  description    = "Policy to grant rights on dynamic group to execute failover scripts"
  name           = var.policy_name
  statements     = ["Allow dynamic-group ${var.dynamic_group_name} to manage public-ips in compartment id ${var.compartment_id}", "Allow dynamic-group ${var.dynamic_group_name} to use subnets in compartment id ${var.compartment_id}", "Allow dynamic-group ${var.dynamic_group_name} to use vnics in tenancy", "Allow dynamic-group ${var.dynamic_group_name} to use private-ips in tenancy"]
}

