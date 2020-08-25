variable vThunder_memory {
  #    default = 8192
}

variable vThunder_CPU {
  #    default = 8 
}

variable vThunder_name_prefix {
  #    default = tf-vm
}

variable vThunder_count {
  #    default = 1
}

provider "proxmox" {
  pm_tls_insecure = true
  pm_api_url      = ""
  pm_password     = ""
  pm_user         = ""
  pm_otp          = ""
}

resource "proxmox_vm_qemu" "proxmox_vm" {
  count       = var.vThunder_count
  name        = "${var.vThunder_name_prefix}-${count.index}"
  target_node = ""
  clone       = "" #Give proxmox template name here
  os_type     = "" #eg cloud-init
  cores       = var.vThunder_CPU
  sockets     = "" #socker count
  cpu         = "host"
  memory      = var.vThunder_memory
  scsihw      = ""
  bootdisk    = ""
  network {
    id     = 0
    model  = "" #Eg virtio
    bridge = "" #Eg vmbr0
  }
  network {
    id     = 1
    model  = ""
    bridge = ""
  }
}
