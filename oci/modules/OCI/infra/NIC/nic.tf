
variable "app_display_name" {
  default = ""
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

#smita changes start
resource "oci_core_vnic_attachment" "client_vnic" {
    #Required
    create_vnic_details {
        #Required
		subnet_id = "${var.oci_subnet_id2}"

        #Optional
        assign_public_ip = true

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
    vnic_id = "${oci_core_vnic_attachment.client_vnic.vnic_id}"   #smita cchange
}

resource "oci_core_vnic_attachment" "server_vnic" {
depends_on = ["oci_core_vnic_attachment.client_vnic"]
    #Required
    create_vnic_details {
        #Required
		subnet_id = "${var.oci_subnet_id3}"

        #Optional
		assign_public_ip = false
        display_name = "${var.client_vnic_display_name}"
<<<<<<< HEAD
=======
        private_ip = "${var.client_vnic_private_ip}"
>>>>>>> 0c0f5adebe9a3d7bd8eeeb07581f184dd8545b46
        skip_source_dest_check = true
    }
    instance_id = "${var.instance_id}"

    #Optional
    display_name = "${var.client_vnic_display_name}"
    #nic_index = "${var.client_vnic_index}"
}

data "oci_core_vnic" "test_vnic_client" {
    #Required
    vnic_id = "${oci_core_vnic_attachment.client_vnic.vnic_id}"
}


data "oci_core_vnic" "test_vnic_server" {
    #Required
    vnic_id = "${oci_core_vnic_attachment.server_vnic.vnic_id}"
}


output "vnic_id" {value = "${oci_core_vnic_attachment.server_vnic.vnic_id}"}

output "eth1_second_private_ip" {value = "${data.oci_core_vnic.test_vnic_client.private_ip_address}"}

output "eth2_private_ip" {value = "${data.oci_core_vnic.test_vnic_server.private_ip_address}"}

output "eth1_sec_private_ip" {value = "${oci_core_private_ip.test_private_ip.ip_address}"}
