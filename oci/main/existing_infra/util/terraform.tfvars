#Provider details
tenancy_ocid   = ""
user_ocid      = ""
compartment_id = ""
region         = "" # region for the instance. e.g: us-ashburn-1

#Login details
private_key_path     = ""
private_key_password = ""
fingerprint          = ""

#vThunder VM details
vm_display_name              = ""
vm_availability_domain       = ""
vm_shape                     = ""
vm_creation_timeout          = ""
vm_primary_vnic_display_name = ""
vm_ssh_public_key_path       = ""


dynamic_group_name = ""
policy_name        = ""

vThunder__image_ocid = ""


#Secondary VNIC details - server
server_vnic_private_ip   = "" #Server vnic private ip
server_vnic_display_name = ""
server_vnic_index        = ""

#Secondary VNIC details - client
client_vnic_private_ip   = "" #Client vnic private ip
client_vnic_display_name = ""
client_vnic_index        = ""

app_display_name = ""

oci_subnet_id1 = "" # first subnet id
oci_subnet_id2 = "" # second subnet id
oci_subnet_id3 = "" # third subnet id

count_vm = "1"
