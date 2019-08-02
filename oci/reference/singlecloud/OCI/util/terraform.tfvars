#Provider details
tenancy_ocid = ""
user_ocid = ""
compartment_id = ""
region = "us-ashburn-1"

#Login details
private_key_path = ""#path
private_key_password = ""#password
fingerprint = ""

#vThunder VM details
vm_display_name = "TF-vThunder"
vm_availability_domain = ""
vm_shape = "VM.Standard2.8"
vm_creation_timeout = "5m"
vm_primary_vnic_display_name = "primary-vnic"
vm_ssh_public_key_path = ""

#Secondary VNIC details - server
server_vnic_private_ip = "10.0.2.10"
server_vnic_display_name = "server"
server_vnic_index = "1"

#Secondary VNIC details - client
client_vnic_private_ip = "10.0.3.10"
client_vnic_display_name = "client"
client_vnic_index = "2"
