#Provider details
tenancy_ocid = ""
user_ocid = ""
compartment_id = "" #QA-BLR
region = "us-ashburn-1"

#Login details
private_key_path = "/home/abc/A10/keys/oci_api_key.pem"
private_key_password = ""
fingerprint = ""

#network details
vcn_cidr = "10.0.0.0/16"
subnet_cidr = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24" ]


#VM details


#vThunder VM details
vThunder__image_ocid= "ocid1.image.oc1.iad.aaaaaaaagc2bl6drev3isly2e3svtksxpwmcdvgkuxc6ctwgqt6rugcbnw5q" #QA-BLR
vm_availability_domain = "paEo:US-ASHBURN-AD-2"
vm_shape = "VM.Standard2.8"
vm_creation_timeout = "5m"
vm_primary_vnic_display_name = "primary-vnic"
vm_ssh_public_key_path = "/home/abc/oci_key.pub"

#Secondary VNIC details - server
server_vnic_display_name = "server-facing"
server_vnic_index = "1"

#Secondary VNIC details - client
client_vnic_display_name = "client-facing"
client_vnic_index = "2"

app_display_name = "app"


#2nd vthunder device details
next_hop_ip = "10.0.2.1"
mgmt_default_gateway = "10.0.1.1"

count_vm = "3"
