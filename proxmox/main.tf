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
  pm_timeout      = 1000
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
  bootdisk    = "scsi0"
  disk {
    id   = 0
    size = 20
    type = "scsi"
    #Modify storage name as per your setup!
    storage      = "local-lvm"
    storage_type = "lvm"
    iothread     = true
  }
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
