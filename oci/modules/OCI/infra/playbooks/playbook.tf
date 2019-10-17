variable "vthunder_vm_public_ip" {
}

variable "vthunder_vm_public_ip2" {
}

variable "password1" {
}

variable "password2" {
}

variable "slb_server_host" {
}

variable "virtual_server_ip" {
}

variable "virtual_server_ip2" {
}

variable "floating_server_private_ip" {
}

variable "vnic_ip1" {
}

variable "next_hop_ip" {
}

variable "mgmt_default_gateway" {
}

variable "client_vnic_private_ip2" {
}

variable "floating_client_private_ip" {
}

variable "client_vnic_private_ip" {
}

variable "instance_id" {
}

variable "instance_id2" {
}

resource "null_resource" "vthunder1_up" {
    triggers = {
      vthunder_id = "${var.instance_id}"
    }
}

resource "null_resource" "vthunder2_up" {
    triggers = {
      vthunder_id = "${var.instance_id2}"
    }
}

resource "null_resource" "test1" {
  provisioner "local-exec" {
    command = <<EOT
          sleep 6m;
          ansible-playbook ../../../../modules/OCI/infra/playbooks/playbook_wo_vrrp.yaml --extra-vars "a10_host='${var.vthunder_vm_public_ip}'  a10_host2='${var.vthunder_vm_public_ip2}' a10_password='${element(split(".",var.password1), 4)}' slb_server_host='${var.slb_server_host}' server_nic_IP='${var.virtual_server_ip2}' server_nic_IP2='${var.virtual_server_ip}' virtual_server='${var.vnic_ip1}' client_nic_ip='${var.client_vnic_private_ip2}' next_hop_ip='${var.next_hop_ip}' floating_client_private_ip='${var.floating_server_private_ip}'  floating_server_private_ip='${var.floating_client_private_ip}' device_id='1' mgmt_default_gateway='${var.mgmt_default_gateway}' ";

          ansible-playbook ../../../../modules/OCI/infra/playbooks/playbook.yaml --extra-vars "a10_host='${var.vthunder_vm_public_ip}'  a10_host2='${var.vthunder_vm_public_ip2}' a10_password='${element(split(".",var.password1), 4)}' slb_server_host='${var.slb_server_host}' server_nic_IP='${var.virtual_server_ip}' server_nic_IP2='${var.virtual_server_ip2}' virtual_server='${var.vnic_ip1}' client_nic_ip='${var.client_vnic_private_ip}' next_hop_ip='${var.next_hop_ip}' floating_client_private_ip='${var.floating_server_private_ip}'  floating_server_private_ip='${var.floating_client_private_ip}' device_id='1' ";

EOT
  }
  depends_on = ["null_resource.vthunder1_up"]
}

resource "null_resource" "test2" {
  provisioner "local-exec" {
    command = <<EOT
    sleep 6m;
    ansible-playbook ../../../../modules/OCI/infra/playbooks/playbook_wo_vrrp.yaml --extra-vars "a10_host='${var.vthunder_vm_public_ip2}' a10_host2='${var.vthunder_vm_public_ip}' a10_password='${element(split(".",var.password2), 4)}' slb_server_host='${var.slb_server_host}' server_nic_IP='${var.virtual_server_ip2}' server_nic_IP2='${var.virtual_server_ip}' virtual_server='${var.vnic_ip1}' client_nic_ip='${var.client_vnic_private_ip2}' next_hop_ip='${var.next_hop_ip}'
    floating_client_private_ip='${var.floating_server_private_ip}' floating_server_private_ip='${var.floating_client_private_ip}' device_id='2'  mgmt_default_gateway='${var.mgmt_default_gateway}' ";

      ansible-playbook ../../../../modules/OCI/infra/playbooks/playbook.yaml --extra-vars "a10_host='${var.vthunder_vm_public_ip2}' a10_host2='${var.vthunder_vm_public_ip2}' a10_password='${element(split(".",var.password2), 4)}' slb_server_host='${var.slb_server_host}' server_nic_IP='${var.virtual_server_ip2}' server_nic_IP2='${var.virtual_server_ip}' virtual_server='${var.vnic_ip1}' client_nic_ip='${var.client_vnic_private_ip2}' next_hop_ip='${var.next_hop_ip}'
      floating_client_private_ip='${var.floating_server_private_ip}' floating_server_private_ip='${var.floating_client_private_ip}' device_id='2'";

EOT
  }
  depends_on = ["null_resource.vthunder2_up"]
}



resource "null_resource" "test3" {
  provisioner "local-exec" {
    command = <<EOT
    ansible-playbook ../../../../modules/OCI/infra/playbooks/playbook_backup.yaml --extra-vars "a10_host='${var.vthunder_vm_public_ip}' a10_password='${element(split(".",var.password1), 4)}' ";
    ansible-playbook ../../../../modules/OCI/infra/playbooks/playbook_backup.yaml --extra-vars "a10_host='${var.vthunder_vm_public_ip2}' a10_password='${element(split(".",var.password2), 4)}' ";

EOT
      }
    depends_on = ["null_resource.test2"]

    }
