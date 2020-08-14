provider "openstack" {
  cloud = "openstack"
}


resource "openstack_compute_secgroup_v2" "secgroup_1" {
  name        = "tf_secgroup"
  description = "terraform security group"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 80
    to_port     = 80
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 443
    to_port     = 443
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

}

output "security_group_id" { value = "${openstack_compute_secgroup_v2.secgroup_1.id}" }
