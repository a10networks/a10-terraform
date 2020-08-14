variable "app_display_name" {
  default = ""
}

variable "compartment_id" {
  description = "Compartment OCID"
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

variable "vm_app_shape" {
  default = "VM.Standard2.1"
}

variable "oci_subnet_id1" {
  description = "oci_subnet_id"
}

variable "oci_subnet_id3" {
  description = "oci_subnet_id"
}

variable "tenancy_ocid" {
  description = "tenancy ocid"
}

variable "vThunder__image_ocid" {
}
variable "vm_count" {
  default = "1"
}

data "oci_core_images" "vThuder_image" {
  compartment_id = "${var.tenancy_ocid}"
  #compartment_id = "${var.compartment_id}"
}

locals {
  vThunder__image_ocid = "${var.vThunder__image_ocid}"
}

resource "oci_core_instance" "vthunder_vm" {
  count          = "${var.vm_count}"
  compartment_id = "${var.compartment_id}"

  display_name = "vthunder-vm-${count.index + 1}"

  availability_domain = "${var.vm_availability_domain}"

  source_details {
    source_id   = "${local.vThunder__image_ocid}"
    source_type = "image"
  }

  shape = "${var.vm_shape}"

  create_vnic_details {
    subnet_id        = "${var.oci_subnet_id1}"
    display_name     = "${var.vm_primary_vnic_display_name}"
    assign_public_ip = true
  }
  metadata = {
    ssh_authorized_keys = "${var.vm_ssh_public_key}"
  }
  timeouts {
    create = "${var.vm_creation_timeout}"
  }
}


##APP SERVER###

/*
resource "oci_core_instance" "app-server" {
  compartment_id = "${var.compartment_id}"
  display_name = "${var.app_display_name}"
  availability_domain = "${var.vm_availability_domain}"

  source_details {
    source_id = "ocid1.image.oc1.iad.aaaaaaaaek6aecdnja3rc6qmimbv4x3cipl5b4mknkxlp4xqpmjbbv43dloa"
    source_type = "image"
  }

  shape = "${var.vm_app_shape}"

  create_vnic_details {
    subnet_id = "${var.oci_subnet_id3}"
    assign_public_ip = false  
    }
  metadata = {
    ssh_authorized_keys = "${file( var.vm_ssh_public_key_path )}"
    user_data = "${base64encode(file("user_data.sh"))}"

  }
  timeouts {
    create = "${var.vm_creation_timeout}"
  }
}
*/


output "ip_active" { value = "${element(oci_core_instance.vthunder_vm.*.public_ip, 0)}" }
output "instance_id_active" { value = "${element(oci_core_instance.vthunder_vm.*.id, 0)}" }
output "ip_list" { value = "${slice(oci_core_instance.vthunder_vm.*.public_ip, 1, length(oci_core_instance.vthunder_vm.*.public_ip))}" }
output "instance_list" { value = "${slice(oci_core_instance.vthunder_vm.*.id, 1, length(oci_core_instance.vthunder_vm.*.id))}" }

