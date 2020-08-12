#Provider details
tenancy_ocid   = "ocid1.tenancy.oc1..aaaaaaaag4vgboeufnpjup6yzug7bmu7oqg7mypie2civld36hcykym2upta"
user_ocid      = "ocid1.user.oc1..aaaaaaaarcli6dmsb36i2jxcmblu4jcyiuwahunn6ajxquzljk4fm3x6ww6q"
compartment_id = "ocid1.compartment.oc1..aaaaaaaawayicdhc6dxp5ay7iqc7gvonb7oanxqb4ufhjne3xc37d6637ona"
region         = "us-ashburn-1" # region for the instance. e.g: us-ashburn-1

#Login details
private_key_path     = "/root/aditya/.oci/oci_key_asharma.pem"
private_key_password = "password"
fingerprint          = "0d:16:2b:2b:ce:66:60:d8:0e:4e:12:db:2d:ce:ca:16"

#vThunder VM details
vm_display_name              = "TF-vThunder"
vm_availability_domain       = "paEo:US-ASHBURN-AD-2"
vm_shape                     = "VM.Standard2.8"
vm_creation_timeout          = "5m"
vm_primary_vnic_display_name = "primary-vnic"
vm_ssh_public_key_path       = "/root/aditya/.ssh/id_rsa.pub"


dynamic_group_name = "dynamic-group-name-test1"
policy_name        = "policy-name-test1"

vThunder__image_ocid = "ocid1.image.oc1.iad.aaaaaaaa23bsqdaajxcnwjptcecpkyaiae6zmkocj3xxfksncrh6pii4mnva"


#Secondary VNIC details - server
server_vnic_private_ip   = "" #Server vnic private ip
server_vnic_display_name = "server"
server_vnic_index        = "1"

#Secondary VNIC details - client
client_vnic_private_ip   = "" #Client vnic private ip
client_vnic_display_name = "client"
client_vnic_index        = "2"

app_display_name = "app"

oci_subnet_id1 = "ocid1.subnet.oc1.iad.aaaaaaaaebkdu77o7ifiq2ulo3p3dmgs6jg3py6oi67ixgrdjrqahrj5aeoq" # first subnet id
oci_subnet_id2 = "ocid1.subnet.oc1.iad.aaaaaaaaqwx2xncanxwjvu5t54acdph4emqpafolmqb2npep653dnkbgkf7a" # second subnet id
oci_subnet_id3 = "ocid1.subnet.oc1.iad.aaaaaaaaj5keb7vgozzqs4fcwrj4vow43m2f2gci5lietirsi3kzabkjau6a" # third subnet id

count_vm = "2"
