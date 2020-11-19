# compute.tf
variable "subnet_ocid" {
  description = "Subnet OCID"
}

variable "compartment_ocid" {
  description = "Compartment OCID"
}

variable "vm_availability_domain" {
  description = "Availability Domain"
}

variable "vm_backend_image_ocid" {
  description = "Backed Image OCID"
}

variable "count_vm" {
  description = "Number of Backend Servers"
}

variable "vm_ssh_public_key_path" {
  description = "Path to ssh public key"
}


resource "oci_core_instance" "backend_vm" {
  count               = var.count_vm
  compartment_id      = var.compartment_ocid
  display_name        = "backend_server-${count.index + 1}"
  availability_domain = var.vm_availability_domain

  source_details {
    source_id   = var.vm_backend_image_ocid # ubuntu image
    source_type = "image"
  }
  shape = "VM.Standard2.1"
  create_vnic_details {
    subnet_id    = var.subnet_ocid
    display_name = "primary-vnic"
    assign_public_ip = true
    hostname_label = "server-${count.index + 1}"
  }
  extended_metadata = {
    ssh_authorized_keys = file(var.vm_ssh_public_key_path)
  }
  timeouts {
    create = "5m"
  }
}
