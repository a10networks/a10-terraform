variable "tenancy_ocid" {
description = "Tenancy OCID"
}

variable "user_ocid" {
description = "User OCID"
}

variable "mgmt_default_gateway" {
}

variable "next_hop_ip" {
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

variable "count_vm"{
  description = "count of vm"
}

#variable "server_vnic_private_ip" {
#description = "server VNIC private ip"
#}


#variable "server_vnic_private_ip2" {
#}

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

/*variable "instance_list" {
    type = "list"
}

variable "instance_id_active"{
}*/


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
 vm_count = "${var.count_vm}"
 tenancy_ocid = "${var.tenancy_ocid}"
 compartment_id = "${var.compartment_id}"
 source = "../../../modules/infra/compute"
 oci_subnet_id1 = "${module.subnet.oci_subnet_id1}"
 oci_subnet_id3 = "${module.subnet.oci_subnet_id3}"
 vm_availability_domain = "${var.vm_availability_domain}"
 vm_shape = "${var.vm_shape}"
 vm_creation_timeout = "${var.vm_creation_timeout}"
 vm_primary_vnic_display_name = "${var.vm_primary_vnic_display_name}"
 vm_ssh_public_key_path = "${var.vm_ssh_public_key_path}"
 app_display_name = "${var.app_display_name}"
 vThunder__image_ocid = "${var.vThunder__image_ocid}"
}

module "nic" {
 source = "../../../modules/infra/NIC"
 oci_subnet_id2 = "${module.subnet.oci_subnet_id2}"
 server_vnic_display_name = "${var.client_vnic_display_name}"
 instance_id_active = "${module.oci_compute.instance_id_active}"
 #instance_id2 = "${module.oci_compute.instance_id2}"
 instance_list = "${module.oci_compute.instance_list}"
 compartment_id = "${var.compartment_id}"
 oci_subnet_id3 = "${module.subnet.oci_subnet_id3}"
 client_vnic_display_name = "${var.server_vnic_display_name}"
 }


/*module "playbooks" {
  source = "../../../modules/infra/playbooks"
  vthunder_vm_public_ip = "${module.oci_compute.ip_active}"
  #vthunder_vm_public_ip2 = "${module.oci_compute.ip2}"
  vthunder_vm_public_ip_list = "${module.oci_compute.ip_list}"
  #password1 = "${element(split(".",module.oci_compute.instance_id),4)}"
  #password2 = "${element(split(".",module.oci_compute.instance_id2),4)}"
  instance_id = "${module.oci_compute.instance_id_active}"
  #instance_id2 = "${module.oci_compute.instance_id2}"
  instance_id_list = "${module.oci_compute.instance_list}"

  client_primary_private_IP = "${module.nic.client_vnic_private_ip}"
  #client_primary_private_IP2 = "${module.nic.client_vnic_private_ip2}"
  client_primary_private_IP2_list = "${module.nic.client_vnic_private_ip2_list}"
  
  client_vip_private_ip = "${module.nic.client_vip_private_ip}"    //VIP pri

  #server_nic_private_IP2 = "${module.nic.server_nic_private_ip2}" #server vnic primary private ip
  server_nic_private_IP2_list = "${module.nic.server_nic_private_ip2_list}" #server vnic primary private ip

  server_nic_private_IP = "${module.nic.server_nic_private_ip}"   #server primary pri

  app_server_IP = "${module.oci_compute.backend_server_ip}"

  floating_client_private_ip = "${module.nic.floating_client_private_ip}"
  floating_server_private_ip = "${module.nic.floating_server_private_ip}"

  next_hop_ip = "${var.next_hop_ip}"
  mgmt_default_gateway = "${var.mgmt_default_gateway}"
}*/


module "oci_network" {
   source = "../../../modules/infra/vcn"
  compartment_id = "${var.compartment_id}"
  vcn_cidr = "${var.vcn_cidr}"
}

module "igw" {
source = "../../../modules/infra/IGW"
compartment_id = "${var.compartment_id}"
vcn_id = "${module.oci_network.id}"
}

module "subnet" {
source = "../../../modules/infra/subnet"
compartment_id = "${var.compartment_id}"
vcn_id = "${module.oci_network.id}"
subnet_cidr = "${var.subnet_cidr}"
vm_availability_domain = "${var.vm_availability_domain}"
default_dhcp_options_id = "${module.oci_network.default_dhcp_options_id}"
route_table_id = "${module.route.route_table_id}"
security_list_ids = "${module.sl.security_list_ids}"
}

module "route" {
source = "../../../modules/infra/route"
compartment_id = "${var.compartment_id}"
vcn_id = "${module.oci_network.id}"
internet_gateway_id = "${module.igw.internet_gateway_id}"
}

module "sl" {
source = "../../../modules/infra/SL"
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
