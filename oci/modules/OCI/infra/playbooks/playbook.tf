variable "vthunder_vm_public_ip" {
}

variable "vthunder_vm_public_ip2" {
}

variable "password1" {
}

variable "password2" {
}

<<<<<<< HEAD
variable "app_server_IP" {
}

variable "floating_server_private_ip" {
}

variable "client_vip_private_ip" {
}

variable "next_hop_ip" {
}

variable "mgmt_default_gateway" {
}

variable "client_primary_private_IP" {
}

variable "floating_client_private_ip" {
}

variable "client_primary_private_IP2" {
}

variable "server_nic_private_IP" {
}

variable "server_nic_private_IP2" {
=======
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
>>>>>>> 0c0f5adebe9a3d7bd8eeeb07581f184dd8545b46
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

resource "null_resource" "active_VT_1" {
  provisioner "local-exec" {
    command = <<EOT
          sleep 6m;

<<<<<<< HEAD
          ansible-playbook ../../../../modules/OCI/infra/playbooks/playbook_slb.yaml --extra-vars "a10_host='${var.vthunder_vm_public_ip}' a10_password='${element(split(".",var.password1), 4)}' app_server_IP='${var.app_server_IP}' client_primary_private_IP='${var.client_primary_private_IP}' client_primary_private_IP2='${var.client_primary_private_IP2}' virtual_server='${var.client_vip_private_ip}' server_nic_private_ip='${var.server_nic_private_IP}' next_hop_ip='${var.next_hop_ip}' mgmt_default_gateway='${var.mgmt_default_gateway}' ";

          ansible-playbook ../../../../modules/OCI/infra/playbooks/playbook_vrrp.yaml --extra-vars "a10_host='${var.vthunder_vm_public_ip}' a10_password='${element(split(".",var.password1), 4)}' client_primary_private_IP='${var.client_primary_private_IP}' client_primary_private_IP2='${var.client_primary_private_IP2}' floating_client_private_ip='${var.floating_client_private_ip}'  floating_server_private_ip='${var.floating_server_private_ip}' device_id='1' ";
=======
          ansible-playbook ../../../../modules/OCI/infra/playbooks/playbook_slb.yaml --extra-vars "a10_host='${var.vthunder_vm_public_ip}' a10_password='${element(split(".",var.password1), 4)}' slb_server_host='${var.slb_server_host}' server_nic_IP='${var.virtual_server_ip}' server_nic_IP2='${var.virtual_server_ip2}' virtual_server='${var.vnic_ip1}' client_nic_ip='${var.client_vnic_private_ip}' next_hop_ip='${var.next_hop_ip}' floating_client_private_ip='${var.floating_client_private_ip}'  floating_server_private_ip='${var.floating_server_private_ip}' device_id='1' mgmt_default_gateway='${var.mgmt_default_gateway}' ";

          ansible-playbook ../../../../modules/OCI/infra/playbooks/playbook_vrrp.yaml --extra-vars "a10_host='${var.vthunder_vm_public_ip}' a10_password='${element(split(".",var.password1), 4)}' slb_server_host='${var.slb_server_host}' server_nic_IP='${var.virtual_server_ip}' server_nic_IP2='${var.virtual_server_ip2}' virtual_server='${var.vnic_ip1}' client_nic_ip='${var.client_vnic_private_ip}' next_hop_ip='${var.next_hop_ip}' floating_client_private_ip='${var.floating_client_private_ip}'  floating_server_private_ip='${var.floating_server_private_ip}' device_id='1' ";
>>>>>>> 0c0f5adebe9a3d7bd8eeeb07581f184dd8545b46

          ansible-playbook ../../../../modules/OCI/infra/playbooks/playbook_harmony_ctrl.yaml --extra-vars "a10_host='${var.vthunder_vm_public_ip}' a10_password='${element(split(".",var.password1), 4)}' ";

EOT
  }
  depends_on = ["null_resource.vthunder1_up"]
}

resource "null_resource" "standby_VT_1" {
  provisioner "local-exec" {
    command = <<EOT
<<<<<<< HEAD
   sleep 6m;
    ansible-playbook ../../../../modules/OCI/infra/playbooks/playbook_slb.yaml --extra-vars "a10_host='${var.vthunder_vm_public_ip2}' a10_password='${element(split(".",var.password2), 4)}' app_server_IP='${var.app_server_IP}' client_primary_private_IP='${var.client_primary_private_IP2}' client_primary_private_IP2='${var.client_primary_private_IP}' virtual_server='${var.client_vip_private_ip}' server_nic_private_ip='${var.server_nic_private_IP2}' next_hop_ip='${var.next_hop_ip}' mgmt_default_gateway='${var.mgmt_default_gateway}' ";

      ansible-playbook ../../../../modules/OCI/infra/playbooks/playbook_vrrp.yaml --extra-vars "a10_host='${var.vthunder_vm_public_ip2}' a10_password='${element(split(".",var.password2), 4)}' client_primary_private_IP='${var.client_primary_private_IP2}' client_primary_private_IP2='${var.client_primary_private_IP}' floating_client_private_ip='${var.floating_client_private_ip}' floating_server_private_ip='${var.floating_server_private_ip}' device_id='2'";
=======
    sleep 6m;
    ansible-playbook ../../../../modules/OCI/infra/playbooks/playbook_slb.yaml --extra-vars "a10_host='${var.vthunder_vm_public_ip2}' a10_password='${element(split(".",var.password2), 4)}' slb_server_host='${var.slb_server_host}' server_nic_IP='${var.virtual_server_ip2}' server_nic_IP2='${var.virtual_server_ip}' virtual_server='${var.vnic_ip1}' client_nic_ip='${var.client_vnic_private_ip2}' next_hop_ip='${var.next_hop_ip}'
    floating_client_private_ip='${var.floating_client_private_ip}' floating_server_private_ip='${var.floating_server_private_ip}' device_id='2'  mgmt_default_gateway='${var.mgmt_default_gateway}' ";

      ansible-playbook ../../../../modules/OCI/infra/playbooks/playbook_vrrp.yaml --extra-vars "a10_host='${var.vthunder_vm_public_ip2}' a10_password='${element(split(".",var.password2), 4)}' slb_server_host='${var.slb_server_host}' server_nic_IP='${var.virtual_server_ip2}' server_nic_IP2='${var.virtual_server_ip}' virtual_server='${var.vnic_ip1}' client_nic_ip='${var.client_vnic_private_ip2}' next_hop_ip='${var.next_hop_ip}'
      floating_client_private_ip='${var.floating_client_private_ip}' floating_server_private_ip='${var.floating_server_private_ip}' device_id='2'";
>>>>>>> 0c0f5adebe9a3d7bd8eeeb07581f184dd8545b46

      ansible-playbook ../../../../modules/OCI/infra/playbooks/playbook_harmony_ctrl.yaml --extra-vars "a10_host='${var.vthunder_vm_public_ip2}' a10_password='${element(split(".",var.password2), 4)}' ";

EOT
  }
  depends_on = ["null_resource.vthunder2_up"]
}
