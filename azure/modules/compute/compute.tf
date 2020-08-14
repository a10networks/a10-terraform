variable "tenant_id" {
}

variable "subscription_id" {
}

variable "client_id" {
}

variable "client_secret" {
}

variable "resource_group_name" {
}

variable "location" {
}

variable "mgmt_nic_id" {
}

variable "server_nic_id" {
  default = ""
}

variable "client_nic_id" {
  default = ""
}

provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.client_id}"
}


# Create virtual machine
resource "azurerm_virtual_machine" "terraformvm" {
  name                = "Terraform-VM"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  #primary_network_interface_id  = "${var.mgmt_nic_id}"
  vm_size               = "Standard_DS3_v2"
  network_interface_ids = ["${var.mgmt_nic_id}"]
  #vm_size               = "Standard_A4"
  delete_os_disk_on_termination = true

  storage_os_disk {
    name              = "OsDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }



  storage_image_reference {
    publisher = "a10networks"
    offer     = "a10-vthunder-adc"
    sku       = "vthunder_byol"
    version   = "latest"
  }

  plan {
    name      = "vthunder_byol"
    publisher = "a10networks"
    product   = "a10-vthunder-adc"
  }

  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  #boot_diagnostics {
  #    enabled = "true"
  #    storage_uri = "${azurerm_storage_account.storageaccount.primary_blob_endpoint}"
  #}

  tags = {
    environment = "Terraform"
  }
}
