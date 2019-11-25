variable "tenancy_ocid" {
description = "Tenancy OCID"
}

variable "mgmt_default_gateway" {
}

variable "next_hop_ip" {
}

variable "compartment_id" {
description = "Compartment OCID"
}

variable "region" {
description = "Region"
}

variable "vm_availability_domain" {
description = "VM availability domain"
}

variable "vm_shape" {
description = "VM shape"
}

variable "vm_primary_vnic_display_name" {
description = "VM primary VNIC display name"
}

variable "vm_ssh_public_key" {
description = "VM ssh public key"
}

variable "vm_creation_timeout" {
description = "VM creation timeout"
}

variable "count_vm"{
  description = "count of vm"
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

variable "vcn_cidr" {
description = "VCN CIDR range"
}

variable "subnet_cidr" {
type = "list"
description = "Subnet CIDR list"
}

provider "oci" {
  version          = ">= 3.24.0"
  region           = "${var.region}"
  auth 			   = "InstancePrincipal"
}

module "oci_compute" {
 vm_count = "${var.count_vm}"
 tenancy_ocid = "${var.tenancy_ocid}"
 compartment_id = "${var.compartment_id}"
 source = "./modules/infra/compute"
 oci_subnet_id1 = "${module.subnet.oci_subnet_id1}"
 oci_subnet_id3 = "${module.subnet.oci_subnet_id3}"
 vm_availability_domain = "${var.vm_availability_domain}"
 vm_shape = "${var.vm_shape}"
 vm_creation_timeout = "${var.vm_creation_timeout}"
 vm_primary_vnic_display_name = "${var.vm_primary_vnic_display_name}"
 vm_ssh_public_key = "${var.vm_ssh_public_key}"
 vThunder__image_ocid = "ocid1.image.oc1.iad.aaaaaaaagc2bl6drev3isly2e3svtksxpwmcdvgkuxc6ctwgqt6rugcbnw5q"
}

module "nic" {
 source = "./modules/infra/NIC"
 oci_subnet_id2 = "${module.subnet.oci_subnet_id2}"
 server_vnic_display_name = "${var.client_vnic_display_name}"
 instance_id_active = "${module.oci_compute.instance_id_active}"
 #instance_id2 = "${module.oci_compute.instance_id2}"
 instance_list = "${module.oci_compute.instance_list}"
 compartment_id = "${var.compartment_id}"
 oci_subnet_id3 = "${module.subnet.oci_subnet_id3}"
 client_vnic_display_name = "${var.server_vnic_display_name}"
}

module "oci_network" {
   source = "./modules/infra/vcn"
  compartment_id = "${var.compartment_id}"
  vcn_cidr = "${var.vcn_cidr}"
}

module "igw" {
source = "./modules/infra/IGW"
compartment_id = "${var.compartment_id}"
vcn_id = "${module.oci_network.id}"
}

module "subnet" {
source = "./modules/infra/subnet"
compartment_id = "${var.compartment_id}"
vcn_id = "${module.oci_network.id}"
subnet_cidr = "${var.subnet_cidr}"
vm_availability_domain = "${var.vm_availability_domain}"
default_dhcp_options_id = "${module.oci_network.default_dhcp_options_id}"
route_table_id = "${module.route.route_table_id}"
security_list_ids = "${module.sl.security_list_ids}"
}

module "route" {
source = "./modules/infra/route"
compartment_id = "${var.compartment_id}"
vcn_id = "${module.oci_network.id}"
internet_gateway_id = "${module.igw.internet_gateway_id}"
}

module "sl" {
source = "./modules/infra/SL"
compartment_id = "${var.compartment_id}"
vcn_id = "${module.oci_network.id}"
}

#output "vnic_ID" {value = "${module.nic.vnic_id}" }

output "instance_list" { value = "${module.oci_compute.instance_list}"}

#output "mgmt_IP" { value = "${module.oci_compute.ip}"}

#output "instance_id" {value = "${module.oci_compute.instance_id}"}

#output "password" {value = "${element(split(".",module.oci_compute.instance_id),4)}"}

#output "mgmt_IP2" { value = "${module.oci_compute.ip2}"}

#output "instance_id2" {value = "${module.oci_compute.instance_id2}"}

#output "password2" {value = "${element(split(".",module.oci_compute.instance_id2),4)}"}
