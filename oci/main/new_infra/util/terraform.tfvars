#Provider details
tenancy_ocid   = ""
user_ocid      = ""
compartment_id = ""
region         = "us-ashburn-1"

#Login details
private_key_path     = ""
private_key_password = ""
fingerprint          = ""

#vThunder VM details
vThunder__image_ocid         = "ocid1.image.oc1..aaaaaaaanh6fkm63h7n2vhffmt47dxng2aptzs3vzy6m2utfak7idif32vta"
vm_shape                     = "VM.Standard2.8"
vm_creation_timeout          = "5m"
vm_primary_vnic_display_name = "primary-vnic"
vm_ssh_public_key_path       = ""
vm_count                     = "1"
vthunder_name                = ""

#VCN
vcn_name = ""
vcn_cidrs =

#Subnet CIDRs - Set 3 CIDRs for primary, client and server subnet
subnet_cidr =

#Secondary VNIC details - server
server_vnic_display_name = "server"
server_vnic_index        = "1"

#Secondary VNIC details - client
client_vnic_display_name = "client"
client_vnic_index        = "2"

