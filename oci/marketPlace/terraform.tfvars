#Provider details
tenancy_ocid = ""
compartment_id = "" #GS-LAB
region = "us-ashburn-1"

#network details
vcn_cidr = "10.0.0.0/16"
subnet_cidr = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24" ]

vm_availability_domain = "paEo:US-ASHBURN-AD-2"
vm_shape = "VM.Standard2.8"
vm_creation_timeout = "5m"
vm_primary_vnic_display_name = "primary-vnic"
vm_ssh_public_key = ""    #public key contents

#Secondary VNIC details - server
#1st vThunder details
server_vnic_display_name = "server-facing"
server_vnic_index = "1"

#Secondary VNIC details - client
client_vnic_display_name = "client-facing"
client_vnic_index = "2"

#2nd vthunder device details
next_hop_ip = "10.0.2.1"
mgmt_default_gateway = "10.0.1.1"

count_vm = "1"         #1st VT will active, remaining will be considered standby
