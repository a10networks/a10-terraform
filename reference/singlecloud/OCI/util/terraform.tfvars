#Provider details
tenancy_ocid = ""
user_ocid = ""
compartment_id = ""
region = "us-ashburn-1"

#Login details
private_key_path = "oci_api_key.pem"
private_key_password = "sameer"
fingerprint = "e7:a6:a1:d2:67:9c:56:ff:74:4c:ab:3f:b1:73:57:de"

#vThunder VM details
vm_display_name = "TF-vThunder"
vm_availability_domain = "paEo:US-ASHBURN-AD-1"
vm_shape = "VM.Standard2.8"
vm_creation_timeout = "5m"
vm_primary_vnic_subnet_id = "ocid1.subnet.oc1.iad.aaaaaaaaw2zlrk6hmxrcpvend224s2zgnoyxb7t6pezwwm4yndt35sbs3t5a"
vm_primary_vnic_display_name = "primary-vnic"
vm_primary_vnic_public_ip = "10.0.0.15"
vm_ssh_public_key_path = "rsa-key-20190514.pub"

#Secondary VNIC details - server
server_vnic_subnet_id = "ocid1.subnet.oc1.iad.aaaaaaaawl6z2223ofs3ptz4ulonwcaosjmrngda2u77ldycubjh6c4rjt4a"
server_vnic_public_ip = ""
server_vnic_private_ip = "10.0.3.10"
server_vnic_display_name = "server"
server_vnic_index = "1"

#Secondary VNIC details - client
client_vnic_subnet_id = "ocid1.subnet.oc1.iad.aaaaaaaawl6z2223ofs3ptz4ulonwcaosjmrngda2u77ldycubjh6c4rjt4a"
client_vnic_public_ip = "10.0.4.10"
client_vnic_private_ip = "10.0.3.10"
client_vnic_display_name = "server"
client_vnic_index = "1"
