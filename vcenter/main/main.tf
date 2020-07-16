variable vsphere_user {
  type        = string
}
variable vsphere_password {
  type        = string
}
variable vsphere_server {}
variable datacenter {} 
variable datastore {}
variable resource_pool {}
variable network_name {}
variable template_name {}
variable vm_name {}
provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = "${var.datacenter}"
}

data "vsphere_datastore" "datastore" {
  name          = "${var.datastore}"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = "${var.resource_pool}"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = "${var.network_name}"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" { 
  name = "${var.template_name}" 
  datacenter_id = "${data.vsphere_datacenter.dc.id}" 
} 

module "compute" {
  source               = "../modules/compute"
  vm_name              = "${var.vm_name}"
  resource_pool_id     = data.vsphere_resource_pool.pool.id
  datastore_id         = data.vsphere_datastore.datastore.id
  num_of_cpu           = 2
  memory               = 8192
  guest_id             = "${data.vsphere_virtual_machine.template.guest_id}"
  scsi_type 	       = "${data.vsphere_virtual_machine.template.scsi_type}"
  network_id           = data.vsphere_network.network.id
  adapter_type         = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
  size                 = "${data.vsphere_virtual_machine.template.disks.0.size}"
  eagerly_scrub        = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
  thin_provisioned     = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
  template_uuid        = "${data.vsphere_virtual_machine.template.id}"
}
