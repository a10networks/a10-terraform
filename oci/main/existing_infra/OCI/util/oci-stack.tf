variable "tenancy_ocid" {
description = "Tenancy OCID"
}

variable "user_ocid" {
description = "User OCID"
}

variable "compartment_id" {
description = "Compartment OCID"
}

variable "app_display_name" {
description = "app display name"
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

variable "server_vnic_index" {
description = "server VNIC index"
}

variable "client_vnic_private_ip" {
description = "client VNIC private ip"
}

variable "client_vnic_display_name" {
description = "client VNIC display name"
}

variable "client_vnic_index" {
description = "client VNIC index"
}

variable "oci_subnet_id1" {
description = "oci_subnet_id1"
}

variable "oci_subnet_id2" {
description = "oci_subnet_id2"
}

variable "oci_subnet_id3" {
description = "oci_subnet_id3"
}

provider "oci" {
  version          = ">= 3.24.0"
  region           = "${var.region}"
  tenancy_ocid     = "${var.tenancy_ocid}"
  user_ocid        = "${var.user_ocid}"
  fingerprint	   = "${var.fingerprint}"
  private_key_path = "${var.private_key_path}"
  private_key_password = "${var.private_key_password}"
  }


module "oci_compute" {
tenancy_ocid = "${var.tenancy_ocid}"
compartment_id = "${var.compartment_id}"
 source = "../../../../modules/OCI/infra/compute"
 oci_subnet_id1 = "${var.oci_subnet_id1}"
 oci_subnet_id3 = "${var.oci_subnet_id3}"
 vm_availability_domain = "${var.vm_availability_domain}"
 vm_shape = "${var.vm_shape}"
 vm_display_name = "${var.vm_display_name}"
 vm_creation_timeout = "${var.vm_creation_timeout}"
 vm_primary_vnic_display_name = "${var.vm_primary_vnic_display_name}"
 vm_ssh_public_key_path = "${var.vm_ssh_public_key_path}" 
 app_display_name = "${var.app_display_name}"  
}

module "nic" {
 source = "../../../../modules/OCI/infra/NIC"
 oci_subnet_id2 = "${var.oci_subnet_id2}"
 server_vnic_display_name = "${var.server_vnic_display_name}"
 server_vnic_private_ip = "${var.server_vnic_private_ip}"
 instance_id = "${module.oci_compute.instance_id}"
 oci_subnet_id3 = "${var.oci_subnet_id3}"
 client_vnic_display_name = "${var.client_vnic_display_name}"
 client_vnic_private_ip = "${var.client_vnic_private_ip}" 
}

output "vnic ID" {value = "${module.nic.vnic_id}" }
