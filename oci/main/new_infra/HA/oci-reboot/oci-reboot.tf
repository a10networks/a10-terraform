variable "vthunder_public_ip" {
  description = "vThunder public IP Address"
}

variable "vthunder_hostname" {
  description = "Set hostname for thunder"
}

provider "thunder" {
  address  = var.vthunder_public_ip
  username = "admin"
  password = "a10"
}

resource "thunder_hostname" "hostname"{
  value = var.vthunder_hostname
}

resource "thunder_write_memory" "write_memory"{
  depends_on = [thunder_hostname.hostname]
# profile = "default"
  destination = "local"
  partition = "all"
}

resource "thunder_reboot" "reboot_thunder" {
      depends_on = [thunder_write_memory.write_memory]
      all = 1
}

