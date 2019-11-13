#Provider details
tenancy_ocid = ""
user_ocid = ""
compartment_id = ""
region = "us-ashburn-1"

#Login details
private_key_path = ""
private_key_password = ""
fingerprint = ""

#vThunder VM details
vm_display_name = "TF-vThunder"
vThunder__image_ocid = "ocid1.image.oc1..aaaaaaaanh6fkm63h7n2vhffmt47dxng2aptzs3vzy6m2utfak7idif32vta"
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

app_display_name = "app"
