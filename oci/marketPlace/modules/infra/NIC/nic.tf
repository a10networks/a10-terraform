variable "app_display_name" {
  default = ""
}

#variable "instance_id2" {
#}

variable "instance_list" {
  type        = "list"
  description = "instance list"
}

variable "instance_id_active" {
  description = "instance id active"
}

variable "compartment_id" {
  description = "Compartment OCID"
  default     = "adas"
}

variable "server_vnic_display_name" {
  description = "server VNIC display name"
}

variable "client_vnic_display_name" {
  description = "client VNIC display name"
}

variable "oci_subnet_id2" {
  description = "oci_subnet_id"
}

variable "oci_subnet_id3" {
  description = "oci_subnet_id"
}

#variable "instance_id" {
#  description = "instance_id"
#}

resource "oci_core_vnic_attachment" "client_vnic" {
  #Required
  create_vnic_details {
    #Required
    subnet_id = "${var.oci_subnet_id2}"

    #Optional
    assign_public_ip = false

    display_name = "${var.server_vnic_display_name}"
    #private_ip = "${var.server_vnic_private_ip}"
    skip_source_dest_check = true
  }
  instance_id = "${var.instance_id_active}"

  #Optional
  display_name = "${var.server_vnic_display_name}"
}

resource "oci_core_private_ip" "client_vnic_private_ip" {
  #Required
  vnic_id = "${oci_core_vnic_attachment.client_vnic.vnic_id}"

}

resource "oci_core_private_ip" "floating_client_private_ip" {
  #Required
  vnic_id    = "${oci_core_vnic_attachment.client_vnic.vnic_id}"
  depends_on = ["oci_core_private_ip.client_vnic_private_ip"]
}

resource "oci_core_public_ip" "vip_public_ip" {
  compartment_id = "${var.compartment_id}"
  display_name   = "reserved public ip 1"
  lifetime       = "RESERVED"
  private_ip_id  = "${oci_core_private_ip.client_vnic_private_ip.id}"
  #defined_tags   = "${oci_core_private_ip.client_vnic_private_ip.defined_tags}"
}

resource "oci_core_vnic_attachment" "server_vnic" {
  depends_on = ["oci_core_vnic_attachment.client_vnic"]
  #Required
  create_vnic_details {
    #Required
    subnet_id = "${var.oci_subnet_id3}"

    #Optional
    assign_public_ip       = false
    display_name           = "${var.client_vnic_display_name}"
    skip_source_dest_check = true
  }
  instance_id = "${var.instance_id_active}"

  #Optional
  display_name = "${var.client_vnic_display_name}"
  #nic_index = "${var.client_vnic_index}"
}

resource "oci_core_private_ip" "floating_server_private_ip" {
  #Required
  depends_on = ["oci_core_vnic_attachment.server_vnic"]
  vnic_id    = "${oci_core_vnic_attachment.server_vnic.vnic_id}"

}

data "oci_core_vnic" "test_vnic_client" {
  #Required
  vnic_id = "${oci_core_vnic_attachment.client_vnic.vnic_id}"
}

data "oci_core_vnic" "test_vnic_server" {
  #Required
  vnic_id = "${oci_core_vnic_attachment.server_vnic.vnic_id}"
}


#2nd Vthuder NIC settings

resource "oci_core_vnic_attachment" "client_vnic2" {
  #for_each = toset(var.instance_list)
  count = "${length(var.instance_list)}"
  #Required
  create_vnic_details {
    #Required
    subnet_id = "${var.oci_subnet_id2}"

    #Optional
    assign_public_ip = false

    display_name = "${var.server_vnic_display_name}"
    #  private_ip = "${var.server_vnic_private_ip2}"
    skip_source_dest_check = true
  }
  instance_id = "${element(var.instance_list, tonumber(count.index))}"

  #Optional
  display_name = "${var.server_vnic_display_name}"
}

resource "oci_core_vnic_attachment" "server_vnic2" {
  #for_each = toset(var.instance_list)
  count      = "${length(var.instance_list)}"
  depends_on = ["oci_core_vnic_attachment.client_vnic2"]
  #Required
  create_vnic_details {
    #Required
    subnet_id = "${var.oci_subnet_id3}"

    #Optional
    assign_public_ip       = false
    display_name           = "${var.client_vnic_display_name}"
    skip_source_dest_check = true
  }
  instance_id = "${element(var.instance_list, tonumber(count.index))}"

  #Optional
  display_name = "${var.client_vnic_display_name}"
  #nic_index = "${var.client_vnic_index}"
}

data "oci_core_vnic" "vt2_vnic_client" {
  #Required
  count = "${length(var.instance_list)}"
  #for_each = toset(oci_core_vnic_attachment.client_vnic2.*.vnic_id)
  vnic_id = "${element(oci_core_vnic_attachment.client_vnic2.*.vnic_id, tonumber(count.index))}"
  #oci_core_vnic_attachment.client_vnic2[count.index].vnic_id
}


data "oci_core_vnic" "vt2_vnic_server" {
  #Required
  count = "${length(var.instance_list)}"
  #for_each = toset(oci_core_vnic_attachment.server_vnic2.*.vnic_id)
  vnic_id = "${element(oci_core_vnic_attachment.server_vnic2.*.vnic_id, tonumber(count.index))}"
}

output "vnic_id" { value = "${oci_core_vnic_attachment.client_vnic.vnic_id}" }

output "client_vnic_private_ip" { value = "${data.oci_core_vnic.test_vnic_client.private_ip_address}" }
#output "client_vnic_private_ip2" {value = "${data.oci_core_vnic.vt2_vnic_client.private_ip_address}"}

output "client_vnic_private_ip2_list" { value = "${data.oci_core_vnic.vt2_vnic_client.*.private_ip_address}" }

output "client_vip_private_ip" { value = "${oci_core_private_ip.client_vnic_private_ip.ip_address}" } #secondary vip private IP

output "server_nic_private_ip" { value = "${data.oci_core_vnic.test_vnic_server.private_ip_address}" }
#output "server_nic_private_ip2" {value = "${data.oci_core_vnic.vt2_vnic_server.private_ip_address}"}

output "server_nic_private_ip2_list" { value = "${data.oci_core_vnic.vt2_vnic_server.*.private_ip_address}" }

#floating IP
output "floating_client_private_ip" { value = "${oci_core_private_ip.floating_client_private_ip.ip_address}" }
output "floating_server_private_ip" { value = "${oci_core_private_ip.floating_server_private_ip.ip_address}" }
