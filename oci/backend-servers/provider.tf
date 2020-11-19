#If user profile exists on the oracle cloud itself.
#provider "oci" {
#  version              = ">= 3.24.0"
#  user_ocid            = ""
#  region               = "us-phoenix-1"
#  tenancy_ocid         = ""
#  fingerprint          = ""
#  private_key_path     = "./keys/oci_api_key.pem"
#  private_key_password = ""
#}


#If user profile exists on any other active directory
provider "oci"{
    auth = "SecurityToken"
    #Specify the config_file_profile name generated using "oci session authenticate" command
    config_file_profile = ""
}
