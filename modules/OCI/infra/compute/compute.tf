# compute.tf

variable "tenancy_ocid" {
description = "Tenancy OCID"
}

variable "user_ocid" {
description = "User OCID"
}

variable "compartment_id" {
description = "Compartment OCID"
default = "adas"
}

variable "region" {
description = "Region"
}
variable "private_key_path" {
description = "Private key file path"
}
variable "private_key_password" {
description = "Private Key Password"
}

variable "fingerprint" {
description = "fingerprint"
}

variable "vm_availability_domain" {
description = "VM availability domain"
}

variable "vm_display_name" {
description = "VM display name"
}

variable "vm_shape" {
description = "VM shape"
}

variable "vm_primary_vnic_display_name" {
description = "VM primary VNIC display name"
}

variable "vm_primary_vnic_public_ip" {
description = "VM primary VNIC public IP"
}

variable "vm_ssh_public_key_path" {
description = "VM ssh public key file path"
}

variable "vm_creation_timeout" {
description = "VM creation timeout"
}

variable "server_vnic_private_ip" {
description = "server VNIC private ip"
}

variable "server_vnic_display_name" {
description = "server VNIC display name"
}

variable "client_vnic_private_ip" {
description = "client VNIC private ip"
}

variable "client_vnic_display_name" {
description = "client VNIC display name"
}

variable oci_subnet_id {
  description = "oci_subnet_id"
}

provider "oci" {
  tenancy_ocid = "${var.tenancy_ocid}"
  user_ocid = "${var.user_ocid}"
  fingerprint = "${var.fingerprint}"
  region = "${var.region}"
  private_key_path = "${var.private_key_path}"
  private_key_password = "${var.private_key_password}"
}

data "oci_core_images" "vThuder_image" {
  compartment_id = "${var.tenancy_ocid}"
 }
locals {
  vThunder__image_ocid = "ocid1.image.oc1..aaaaaaaai3isjh6znmwpju7bahjzqek2v3w7l2iipffj4gikyfz752f7avqq"
  }

resource "oci_core_instance" "vthunder_vm" {
  compartment_id = "${var.compartment_id}"
  display_name = "${var.vm_display_name}"
  availability_domain = "${var.vm_availability_domain}"

  source_details {
    source_id = "${local.vThunder__image_ocid}"
    source_type = "image"
  }

  shape = "${var.vm_shape}"

  create_vnic_details {
    subnet_id = "${var.oci_subnet_id}"
    display_name = "${var.vm_primary_vnic_display_name}"
    assign_public_ip = true
    private_ip = "${var.vm_primary_vnic_public_ip}"
  }
  metadata {
    ssh_authorized_keys = "${file( var.vm_ssh_public_key_path )}"
  }
  timeouts {
    create = "${var.vm_creation_timeout}"
  }
}




resource "oci_core_vnic_attachment" "server_vnic" {
    #Required
    create_vnic_details {
        #Required
		subnet_id = "${var.oci_subnet_id}"

        #Optional
        display_name = "${var.server_vnic_display_name}"
        private_ip = "${var.server_vnic_private_ip}"
        skip_source_dest_check = true
    }
    instance_id = "${oci_core_instance.vthunder_vm.id}"

    #Optional
    display_name = "${var.server_vnic_display_name}"
}


resource "oci_core_vnic_attachment" "client_vnic" {
    #Required
    create_vnic_details {
        #Required
		subnet_id = "${var.oci_subnet_id}"

        #Optional
		assign_public_ip = true
        #public_ip = "${var.client_vnic_public_ip}"
        display_name = "${var.client_vnic_display_name}"
        private_ip = "${var.client_vnic_private_ip}"
        skip_source_dest_check = true
    }
    instance_id = "${oci_core_instance.vthunder_vm.id}"

    #Optional
    display_name = "${var.client_vnic_display_name}"
    #nic_index = "${var.client_vnic_index}"
}
