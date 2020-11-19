#Parameters Needed for User authentication
#Required by OCI provider (If user profile exists on oci cloud)
user_ocid      = ""
region         = ""
private_key_password = ""
tenancy_ocid            = ""
compartment_id          = ""
fingerprint = ""
private_key_path = "./keys/oci_api_key.pem"

#delay before reboot in seconds
delay_before_reboot = "240s"


#network details
vcn_cidr    = "10.0.0.0/16"
subnet_cidr = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

#VM details

#vThunder VM details
vThunder__image_ocid = ""

#vm_availability_domain = ["LjsV:PHX-AD-2", "LjsV:PHX-AD-3"]
vm_shape                     = "VM.Standard2.4"
vm_creation_timeout          = "5m"
vm_primary_vnic_display_name = "primary-vnic"
vm_ssh_public_key_path = "./keys/id_rsa.pub"

#Secondary VNIC details - server
server_vnic_display_name = "server-facing"
server_vnic_index        = "1"

#Secondary VNIC details - client
client_vnic_display_name = "client-facing"
client_vnic_index        = "2"

next_hop_ip          = "10.0.2.1"
mgmt_default_gateway = "10.0.1.1"

dynamic_group_name = ""
policy_name        = ""

count_vm = "1"

