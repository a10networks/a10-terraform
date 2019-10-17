variable "app_display_name" {
  default = ""
}

variable "instance_id2" {
}

variable "server_vnic_private_ip2" {
}

variable "client_vnic_private_ip2" {
}


variable "compartment_id" {
description = "Compartment OCID"
default = "adas"
}


variable "server_vnic_private_ip" {
description = "server VNIC private ip"
}

variable "server_vnic_display_name" {
description = "server VNIC display name"
}

variable "vm_app_shape" {
  default = "VM.Standard2.1"
}
variable "client_vnic_private_ip" {
description = "client VNIC private ip"
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

variable "instance_id" {
  description = "instance_id"
}

resource "oci_core_vnic_attachment" "server_vnic" {
    #Required
    create_vnic_details {
        #Required
		subnet_id = "${var.oci_subnet_id2}"

        #Optional
        assign_public_ip = false

        display_name = "${var.server_vnic_display_name}"
        private_ip = "${var.server_vnic_private_ip}"
        skip_source_dest_check = true
    }
    instance_id = "${var.instance_id}"

    #Optional
    display_name = "${var.server_vnic_display_name}"
}

resource "oci_core_private_ip" "test_private_ip" {
    #Required
    vnic_id = "${oci_core_vnic_attachment.server_vnic.vnic_id}"

}

resource "oci_core_private_ip" "floating_server_private_ip" {
    #Required
    vnic_id = "${oci_core_vnic_attachment.server_vnic.vnic_id}"
    depends_on = ["oci_core_private_ip.test_private_ip"]
}

resource "oci_core_public_ip" "pubip1" {
compartment_id = "${var.compartment_id}"
display_name   = "reserved public ip 1"
lifetime       = "RESERVED"
private_ip_id  = "${oci_core_private_ip.test_private_ip.id}"
#defined_tags   = "${oci_core_private_ip.test_private_ip.defined_tags}"
}



resource "oci_core_vnic_attachment" "client_vnic" {
depends_on = ["oci_core_vnic_attachment.server_vnic"]
    #Required
    create_vnic_details {
        #Required
		subnet_id = "${var.oci_subnet_id3}"

        #Optional
		assign_public_ip = false
        display_name = "${var.client_vnic_display_name}"
        private_ip = "${var.client_vnic_private_ip}"
        skip_source_dest_check = true
    }
    instance_id = "${var.instance_id}"

    #Optional
    display_name = "${var.client_vnic_display_name}"
    #nic_index = "${var.client_vnic_index}"
}

resource "oci_core_private_ip" "floating_client_private_ip" {
    #Required
    depends_on = ["oci_core_vnic_attachment.client_vnic"]
    vnic_id = "${oci_core_vnic_attachment.client_vnic.vnic_id}"

}

data "oci_core_vnic" "test_vnic_server" {
    #Required
    vnic_id = "${oci_core_vnic_attachment.server_vnic.vnic_id}"
}

data "oci_core_vnic" "test_vnic_client" {
    #Required
    vnic_id = "${oci_core_vnic_attachment.client_vnic.vnic_id}"
}




#2nd Vthuder NIC settings

resource "oci_core_vnic_attachment" "server_vnic2" {
    #Required
    create_vnic_details {
        #Required
		subnet_id = "${var.oci_subnet_id2}"

        #Optional
        assign_public_ip = false

        display_name = "${var.server_vnic_display_name}"
        private_ip = "${var.server_vnic_private_ip2}"
        skip_source_dest_check = true
    }
    instance_id = "${var.instance_id2}"

    #Optional
    display_name = "${var.server_vnic_display_name}"
}

# resource "oci_core_private_ip" "test_private_ip2" {
#     #Required
#     depends_on = ["oci_core_vnic_attachment.server_vnic2"]
#     vnic_id = "${oci_core_vnic_attachment.server_vnic2.vnic_id}"
#
# }


#
# resource "oci_core_public_ip" "pubip2" {
# compartment_id = "${var.compartment_id}"
# display_name   = "reserved public ip 2"
# lifetime       = "RESERVED"
# private_ip_id  = "${oci_core_private_ip.test_private_ip2.id}"
# #defined_tags   = "${oci_core_private_ip.test_private_ip.defined_tags}"
# }

/*

resource "oci_core_private_ip" "floating_server_private_ip2" {
    #Required
    vnic_id = "${oci_core_vnic_attachment.server_vnic2.vnic_id}"
    depends_on = ["oci_core_private_ip.test_private_ip2"]
}

*/
resource "oci_core_vnic_attachment" "client_vnic2" {
depends_on = ["oci_core_vnic_attachment.server_vnic2"]
    #Required
    create_vnic_details {
        #Required
		subnet_id = "${var.oci_subnet_id3}"

        #Optional
		assign_public_ip = false
        display_name = "${var.client_vnic_display_name}"
        private_ip = "${var.client_vnic_private_ip2}"
        skip_source_dest_check = true
    }
    instance_id = "${var.instance_id2}"

    #Optional
    display_name = "${var.client_vnic_display_name}"
    #nic_index = "${var.client_vnic_index}"
}

/*

resource "oci_core_private_ip" "floating_client_private_ip2" {
    #Required
    depends_on = ["oci_core_vnic_attachment.client_vnic2"]
    vnic_id = "${oci_core_vnic_attachment.client_vnic2.vnic_id}"

}
*/



output "vnic_id" {value = "${oci_core_vnic_attachment.server_vnic.vnic_id}"}

output "eth1_second_private_ip" {value = "${data.oci_core_vnic.test_vnic_server.private_ip_address}"}

output "eth2_private_ip" {value = "${data.oci_core_vnic.test_vnic_client.private_ip_address}"}

output "eth1_sec_private_ip" {value = "${oci_core_private_ip.test_private_ip.ip_address}"}

#output "eth1_sec_private_ip2" {value = "${oci_core_private_ip.test_private_ip2.ip_address}"}

#floating IP
output "floating_server_private_ip" {value = "${oci_core_private_ip.floating_server_private_ip.ip_address}"}
output "floating_client_private_ip" {value = "${oci_core_private_ip.floating_client_private_ip.ip_address}"}

#output "floating_server_private_ip2" {value = "${oci_core_private_ip.floating_server_private_ip2.ip_address}"}
#output "floating_client_private_ip2" {value = "${oci_core_private_ip.floating_client_private_ip2.ip_address}"}
