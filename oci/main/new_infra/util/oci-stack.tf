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

variable "vThunder__image_ocid" {
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


provider "oci" {
  version              = ">= 3.24.0"
  region               = "${var.region}"
  tenancy_ocid         = "${var.tenancy_ocid}"
  user_ocid            = "${var.user_ocid}"
  fingerprint          = "${var.fingerprint}"
  private_key_path     = "${var.private_key_path}"
  private_key_password = "${var.private_key_password}"
}


module "oci_compute" {
  tenancy_ocid                 = "${var.tenancy_ocid}"
  compartment_id               = "${var.compartment_id}"
  source                       = "../../../modules/infra/compute"
  oci_subnet_id1               = "${module.subnet.oci_subnet_id1}"
  oci_subnet_id3               = "${module.subnet.oci_subnet_id3}"
  vm_availability_domain       = "${var.vm_availability_domain}"
  vm_shape                     = "${var.vm_shape}"
  vm_display_name              = "${var.vm_display_name}"
  vm_creation_timeout          = "${var.vm_creation_timeout}"
  vm_primary_vnic_display_name = "${var.vm_primary_vnic_display_name}"
  vm_ssh_public_key_path       = "${var.vm_ssh_public_key_path}"
  app_display_name             = "${var.app_display_name}"
  vThunder__image_ocid         = "${var.vThunder__image_ocid}"
}

module "nic" {
  source                   = "../../../modules/infra/NIC"
  oci_subnet_id2           = "${module.subnet.oci_subnet_id2}"
  server_vnic_display_name = "${var.server_vnic_display_name}"
  server_vnic_private_ip   = "${var.server_vnic_private_ip}"
  instance_id              = "${module.oci_compute.instance_id}"
  oci_subnet_id3           = "${module.subnet.oci_subnet_id3}"
  client_vnic_display_name = "${var.client_vnic_display_name}"
}

module "oci_network" {
  source         = "../../../modules/infra/vcn"
  compartment_id = "${var.compartment_id}"
}

module "igw" {
  source         = "../../../modules/infra/IGW"
  compartment_id = "${var.compartment_id}"
  vcn_id         = "${module.oci_network.id}"
}

module "subnet" {
  source                  = "../../../modules/infra/subnet"
  compartment_id          = "${var.compartment_id}"
  vcn_id                  = "${module.oci_network.id}"
  vm_availability_domain  = "${var.vm_availability_domain}"
  default_dhcp_options_id = "${module.oci_network.default_dhcp_options_id}"
  route_table_id          = "${module.route.route_table_id}"
  security_list_ids       = "${module.sl.security_list_ids}"
}

module "route" {
  source              = "../../../modules/infra/route"
  compartment_id      = "${var.compartment_id}"
  vcn_id              = "${module.oci_network.id}"
  internet_gateway_id = "${module.igw.internet_gateway_id}"
}

module "sl" {
  source         = "../../../modules/infra/SL"
  compartment_id = "${var.compartment_id}"
  vcn_id         = "${module.oci_network.id}"
}

output "vnic ID" { value = "${module.nic.vnic_id}" }
