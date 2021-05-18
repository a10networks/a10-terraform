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

variable "vThunder__image_ocid" {
}

variable "vm_count" {
  description = "Number of vThunder will be created"
}

variable "vthunder_name" {
  description = "vThunder name"
}

variable "fingerprint" {
  description = "fingerprint"
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

variable "server_vnic_display_name" {
  description = "server VNIC display name"
}

variable "server_vnic_index" {
  description = "server VNIC index"
}

variable "client_vnic_display_name" {
  description = "client VNIC display name"
}

variable "client_vnic_index" {
  description = "client VNIC index"
}

variable "vcn_name" {
  description = "VCN name"
}

variable "vcn_cidrs" {
  description = "VCN cidrs"
}

variable "subnet_cidr" {
  description = "Subnet cidr"
}

terraform {
  required_providers {
    oci = {
      source  = "hashicorp/oci"
      version = "~> 4.24.0"
    }
  }
}
provider "oci" {
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
  #oci_subnet_id3               = "${module.subnet.oci_subnet_id3}"
  #vm_availability_domain       = "${var.vm_availability_domain}"
  vm_shape                     = "${var.vm_shape}"
  vm_creation_timeout          = "${var.vm_creation_timeout}"
  vm_primary_vnic_display_name = "${var.vm_primary_vnic_display_name}"
  vm_ssh_public_key_path       = "${var.vm_ssh_public_key_path}"
  vThunder__image_ocid         = "${var.vThunder__image_ocid}"
  count_vm		       = "${var.vm_count}"
  vthunder_name                = "${var.vthunder_name}"
}

module "nic" {
  source                   = "../../../modules/infra/NIC"
  oci_subnet_id2           = "${module.subnet.oci_subnet_id2}"
  server_vnic_display_name = "${var.server_vnic_display_name}"
  oci_subnet_id3           = "${module.subnet.oci_subnet_id3}"
  client_vnic_display_name = "${var.client_vnic_display_name}"
  instance_id_active       = "${module.oci_compute.instance_id_active}"
}

module "oci_network" {
  source         = "../../../modules/infra/vcn"
  compartment_id = "${var.compartment_id}"
  vcn_name       = "${var.vcn_name}"
  vcn_cidrs	 = "${var.vcn_cidrs}"
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
  default_dhcp_options_id = "${module.oci_network.default_dhcp_options_id}"
  route_table_id          = "${module.route.route_table_id}"
  security_list_ids       = "${module.sl.security_list_ids}"
  subnet_cidr             = "${var.subnet_cidr}"
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

output "vnic_ID" { value = "${module.nic.vnic_id}" }
