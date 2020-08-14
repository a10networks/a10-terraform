# libvirt.tf

provider "libvirt" {
  uri = "qemu:///system"
}

variable subnets {
  type = "list"
}

variable network_names {
  type = "list"
}



resource "libvirt_network" "public" {
  count     = "${length(var.subnets)}" #two pubic subnets- one for mgmt NIC and other for client NIC
  name      = "${var.network_names[count.index]}"
  bridge    = "br_${var.network_names[count.index]}"
  mode      = "nat"
  addresses = ["${var.subnets[count.index]}"]
  dhcp {
    enabled = true
  }
}

output "public_network_name" { value = "${libvirt_network.public.*.name}" }
