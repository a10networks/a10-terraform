variable vm_name {}
variable network_name1 {}
variable network_name2 {}
variable image_path {}

# create pool
resource "libvirt_pool" "ubuntu" {
 name = "${var.vm_name}-ubuntu-pool"
 type = "dir"
 path = "/libvirt_images/${var.vm_name}-ubuntu-pool/"
}

# create image
resource "libvirt_volume" "image-qcow2" {
 name = "${var.vm_name}-ubuntu-amd64.qcow2"
 pool = libvirt_pool.ubuntu.name
 source ="${var.image_path}"
 format = "qcow2"
}

# add cloudinit disk to pool
resource "libvirt_cloudinit_disk" "commoninit" {
 name = "commoninit.iso"
 pool = libvirt_pool.ubuntu.name
 user_data = data.template_file.user_data.rendered
}

# read the configuration
data "template_file" "user_data" {
 template = file("./modules/config/cloud_init.cfg") 
}

resource "null_resource" "delay" {
  provisioner "local-exec" {
    command = "sleep 60"
  }
}

resource "null_resource" "after" {
  depends_on = ["null_resource.delay"]
}

resource "libvirt_domain" "Domain" {

 # name should be unique!
   name = "${var.vm_name}"
   autostart = true
   memory = "4096"
   vcpu = 1
 # add the cloud init disk to share user data
   cloudinit = libvirt_cloudinit_disk.commoninit.id  #set to default libvirt network
   depends_on = ["null_resource.after"]
   network_interface {
   network_name = "default"
   }
   network_interface {
   network_name = "${var.network_name1}"
   }
   network_interface {
   network_name = "${var.network_name2}"
   }
   console {
   type = "pty"
   target_type = "serial"
   target_port = "0"
   }
   disk {
   volume_id = libvirt_volume.image-qcow2.id
   }
  graphics {
   type = "spice"
   listen_type = "address"
   autoport = true
 }
}
