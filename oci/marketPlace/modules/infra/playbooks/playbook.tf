variable "vthunder_vm_public_ip" {
}

#variable "vthunder_vm_public_ip2" {
#}

variable "vthunder_vm_public_ip_list" {
  type = "list"
}


/*variable "password1" {
}

variable "password2" {
}*/

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

#variable "client_primary_private_IP2" {
#}

variable "client_primary_private_IP2_list" {
  type = "list"
}


variable "server_nic_private_IP" {
}

#variable "server_nic_private_IP2" {
#}

variable "server_nic_private_IP2_list" {
  type = "list"
}


variable "instance_id" {
}

#variable "instance_id2" {
#}

variable "instance_id_list" {
  type = "list"
}


resource "null_resource" "vthunder1_up" {
    triggers = {
      vthunder_id = "${var.instance_id}"
    }
}

resource "null_resource" "vthunder2_up" {
  count = "${length(var.instance_id_list)}"
    triggers = {
      vthunder_id = "${element(var.instance_id_list,tonumber(count.index))}"
    }
}

resource "null_resource" "active_VT_1" {
  //ansible-playbook ../../../../modules/OCI/infra/playbooks/playbook_vrrp.yaml --extra-vars "a10_host='${var.vthunder_vm_public_ip}' a10_password='${element(split(".",var.password1), 4)}' client_primary_private_IP='${var.client_primary_private_IP}' client_primary_private_IP2='${var.client_primary_private_IP2}' floating_client_private_ip='${var.floating_client_private_ip}'  floating_server_private_ip='${var.floating_server_private_ip}' device_id='1' ";
  //ansible-playbook ../../../../modules/OCI/infra/playbooks/playbook_slb.yaml --extra-vars "a10_host='${var.vthunder_vm_public_ip}' a10_password='${element(split(".",var.password1), 4)}' app_server_IP='${var.app_server_IP}' client_primary_private_IP='${var.client_primary_private_IP}' virtual_server='${var.client_vip_private_ip}' server_nic_private_ip='${var.server_nic_private_IP}' next_hop_ip='${var.next_hop_ip}' mgmt_default_gateway='${var.mgmt_default_gateway}' ";
  provisioner "local-exec" {
    command = <<EOT
          sleep 6m;

          

          

          ansible-playbook ../../../../modules/OCI/infra/playbooks/playbook_harmony_ctrl.yaml --extra-vars "a10_host='${var.vthunder_vm_public_ip}' a10_password='${element(split(".",var.instance_id),4)}' ";

EOT
  }
  depends_on = ["null_resource.vthunder1_up"]
}

/*resource "null_resource" "standby_VT_1" {

  //ansible-playbook ../../../../modules/OCI/infra/playbooks/playbook_vrrp.yaml --extra-vars "a10_host='${var.vthunder_vm_public_ip2}' a10_password='${element(split(".",var.password2), 4)}' client_primary_private_IP='${var.client_primary_private_IP2}' client_primary_private_IP2='${var.client_primary_private_IP}' floating_client_private_ip='${var.floating_client_private_ip}' floating_server_private_ip='${var.floating_server_private_ip}' device_id='2'";
  provisioner "local-exec" {
    command = <<EOT
    sleep 6m;
    ansible-playbook ../../../../modules/OCI/infra/playbooks/playbook_slb.yaml --extra-vars "a10_host='${var.vthunder_vm_public_ip2}' a10_password='${element(split(".",var.password2), 4)}' app_server_IP='${var.app_server_IP}' client_primary_private_IP='${var.client_primary_private_IP2}' virtual_server='${var.client_vip_private_ip}' server_nic_private_ip='${var.server_nic_private_IP2}' next_hop_ip='${var.next_hop_ip}' mgmt_default_gateway='${var.mgmt_default_gateway}' ";

      

      ansible-playbook ../../../../modules/OCI/infra/playbooks/playbook_harmony_ctrl.yaml --extra-vars "a10_host='${var.vthunder_vm_public_ip2}' a10_password='${element(split(".",var.password2), 4)}' ";

EOT
  }
  depends_on = ["null_resource.vthunder2_up"]
}*/
