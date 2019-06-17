variable "tenancy_ocid" {
description = "Tenancy OCID"
}

variable "user_ocid" {
description = "User OCID"
}

variable "compartment_id" {
description = "Compartment OCID"
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

variable "vm_primary_vnic_subnet_id" {
description = "VM primary subnet id"
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

variable "server_vnic_subnet_id" {
description = "server VNIC subnet id"
}

variable "server_vnic_public_ip" {
description = "server VNIC public ip"
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

variable "client_vnic_subnet_id" {
description = "client VNIC subnet id"
}

variable "client_vnic_public_ip" {
description = "client VNIC public ip"
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





module "oci_compute" {
  source = "../../../../modules/OCI/infra/compute"
  oci_subnet_id = "${module.oci_network.oci_subnet_id}"
  vm_availability_domain = "${var.vm_availability_domain}"
  vm_shape = "${var.vm_shape}"
  vm_primary_vnic_public_ip = "${var.vm_primary_vnic_public_ip}"
  tenancy_ocid = "${var.tenancy_ocid}"
  region = "${var.region}"
  server_vnic_private_ip = "${var.server_vnic_private_ip}"
  tenancy_ocid = "${var.tenancy_ocid}"
  user_ocid = "${var.user_ocid}"
  compartment_id = "${var.compartment_id}"
  region = "${var.region}"

  #Login details
  private_key_path = "${var.private_key_path}"
  private_key_password = "${var.private_key_password}"
  fingerprint = "${var.fingerprint}"

  #vThunder VM details
  vm_display_name = "${var.vm_display_name}"
  vm_availability_domain = "${var.vm_availability_domain}"
  vm_shape = "${var.vm_shape}"
  vm_creation_timeout = "${var.vm_creation_timeout}"
  vm_primary_vnic_display_name = "${var.vm_primary_vnic_display_name}"
  vm_primary_vnic_public_ip = "${var.vm_primary_vnic_public_ip}"
  vm_ssh_public_key_path = "${var.vm_ssh_public_key_path}"

  #Secondary VNIC details - server
  server_vnic_private_ip = "${var.server_vnic_private_ip}"
  server_vnic_display_name = "${var.server_vnic_display_name}"

  #Secondary VNIC details - client
  client_vnic_private_ip = "${var.client_vnic_private_ip}"
  client_vnic_display_name = "${var.client_vnic_display_name}"


}



module "oci_network" {

  source = "../../../../modules/OCI/infra/network"
  #Provider details
  tenancy_ocid = "${var.tenancy_ocid}"
  user_ocid = "${var.user_ocid}"
  compartment_id = "${var.compartment_id}"
  region = "${var.region}"

  #Login details
  private_key_path = "${var.private_key_path}"
  private_key_password = "${var.private_key_password}"
  fingerprint = "${var.fingerprint}"

  #vThunder VM details
  vm_display_name = "${var.vm_display_name}"
  vm_availability_domain = "${var.vm_availability_domain}"
  vm_shape = "${var.vm_shape}"
  vm_creation_timeout = "${var.vm_creation_timeout}"
  vm_primary_vnic_subnet_id = "${var.vm_primary_vnic_subnet_id}"
  vm_primary_vnic_display_name = "${var.vm_primary_vnic_display_name}"
  vm_primary_vnic_public_ip = "${var.vm_primary_vnic_public_ip}"
  vm_ssh_public_key_path = "${var.vm_ssh_public_key_path}"

  #Secondary VNIC details - server
  server_vnic_subnet_id = "${var.server_vnic_subnet_id}"
  server_vnic_public_ip = "${var.server_vnic_public_ip}"
  server_vnic_private_ip = "${var.server_vnic_private_ip}"
  server_vnic_display_name = "${var.server_vnic_display_name}"
  server_vnic_index = "${var.server_vnic_index}"

  #Secondary VNIC details - client
  client_vnic_subnet_id = "${var.client_vnic_subnet_id}"
  client_vnic_public_ip = "${var.client_vnic_public_ip}"
  client_vnic_private_ip = "${var.client_vnic_private_ip}"
  client_vnic_display_name = "${var.client_vnic_display_name}"
  client_vnic_index = "${var.client_vnic_index}"


}
