#Provider details
tenancy_ocid = ""
user_ocid = ""
compartment_id = ""
region = "" # region for the instance. e.g: us-ashburn-1

#Login details
private_key_path = ""
private_key_password = ""
fingerprint = ""

#vThunder VM details
vm_display_name = "TF-vThunder"
vm_availability_domain = ""
vm_shape = "VM.Standard2.8"
vm_creation_timeout = "5m"
vm_primary_vnic_display_name = "primary-vnic"
vm_ssh_public_key_path = ""

#Secondary VNIC details - server
server_vnic_private_ip = ""  #Server vnic private ip
server_vnic_display_name = "server"
server_vnic_index = "1"

#Secondary VNIC details - client
client_vnic_private_ip = ""  #Client vnic private ip
client_vnic_display_name = "client"
client_vnic_index = "2"

app_display_name = "app"
oci_subnet_id1 = ""  # first subnet id
oci_subnet_id2 = ""  # second subnet id
oci_subnet_id3 = ""  # third subnet id
