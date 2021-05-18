variable "compartment_id" {
  description = "Compartment OCID"
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

variable "vm_app_shape" {
  default = "VM.Standard2.1"
}

variable "oci_subnet_id1" {
  description = "oci_subnet_id"
}

variable "tenancy_ocid" {
  description = "tenancy ocid"
}

variable "vThunder__image_ocid" {
}

variable "count_vm" {
  default = "1"
}

variable "vthunder_name" {
  description = "name of new vThunder"
  default = "vm"
}

data "oci_core_images" "vThuder_image" {
  compartment_id = var.compartment_id
}

locals {
  vThunder__image_ocid = var.vThunder__image_ocid
}

resource "oci_core_instance" "vthunder_vm" {
  count          = var.count_vm
  compartment_id = var.compartment_id

  display_name = "vthunder-${var.vthunder_name}-${count.index + 1}"

  availability_domain = element(data.oci_identity_availability_domains.compartment_availability_domains.availability_domains, random_integer.availability_domain_id.result + count.index).name

  source_details {
    source_id   = local.vThunder__image_ocid
    source_type = "image"
  }

  shape = var.vm_shape

  create_vnic_details {
    subnet_id        = var.oci_subnet_id1
    display_name     = var.vm_primary_vnic_display_name
    assign_public_ip = true
  }
  metadata = {
    ssh_authorized_keys = file(var.vm_ssh_public_key_path)
    user_data           = base64encode(file("passwd_reset.yaml"))
  }
  timeouts {
    create = var.vm_creation_timeout
  }
}

resource "random_integer" "availability_domain_id" {
  min = 0
  max = length(data.oci_identity_availability_domains.compartment_availability_domains.availability_domains) - 1
}

data "oci_identity_availability_domains" "compartment_availability_domains" {
  #Required
  compartment_id = var.compartment_id
}

output "ip_active" { value = element(oci_core_instance.vthunder_vm.*.public_ip, 0) }
output "instance_id_active" { value = element(oci_core_instance.vthunder_vm.*.id, 0) }

output "ip_list" { value = slice(oci_core_instance.vthunder_vm.*.public_ip, 0, length(oci_core_instance.vthunder_vm.*.public_ip)) }
output "instance_list" { value = slice(oci_core_instance.vthunder_vm.*.id, 1, length(oci_core_instance.vthunder_vm.*.id)) }
output "instance_list_full" { value = slice(oci_core_instance.vthunder_vm.*.id, 0, length(oci_core_instance.vthunder_vm.*.id)) }

output "availability_domains" { value = data.oci_identity_availability_domains.compartment_availability_domains.availability_domains }
