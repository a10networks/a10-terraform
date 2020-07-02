variable vm_name {}
variable image_path {}
variable subnets {
type = "list"
}
variable network_names {
type = "list"
}

# add the provider
provider "libvirt" {
 uri = "qemu:///system"
}

# run the network

module "network-module" {
   source = "./modules/networks/"
   subnets = "${var.subnets}"
   network_names = "${var.network_names}"
}

# Define KVM domain to create

module "VM-module" {
   source = "./modules/compute/"
   vm_name = "${var.vm_name}"
   image_path = "${var.image_path}"
   network_name1 = "${element(var.network_names,0)}"
   network_name2 = "${element(var.network_names,1)}"

}
