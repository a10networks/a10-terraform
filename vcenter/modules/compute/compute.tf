variable vm_name {}
variable resource_pool_id {}
variable datastore_id {}
variable num_of_cpu {}
variable memory {}
variable guest_id {}
variable scsi_type {}
variable network_id {}
variable adapter_type {}
variable size {}
variable eagerly_scrub {}
variable thin_provisioned {}
variable template_uuid {}


resource "vsphere_virtual_machine" "vm" {
  name             = "${var.vm_name}"
  resource_pool_id = "${var.resource_pool_id}"
  datastore_id     = "${var.datastore_id}"
  num_cpus         = "${var.num_of_cpu}"
  memory           = "${var.memory}"
  guest_id         = "${var.guest_id}"
  scsi_type        = "${var.scsi_type}"
  network_interface {
    network_id   = "${var.network_id}"
    adapter_type = "${var.adapter_type}"
  }

  disk {
    label            = "disk0"
    size             = "${var.size}"
    eagerly_scrub    = "${var.eagerly_scrub}"
    thin_provisioned = "${var.thin_provisioned}"
  }

  clone {
    template_uuid = "${var.template_uuid}"
  }
}
