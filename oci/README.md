
#Building a docker image

1. git clone this repo
2. docker build . -t a10/a10-terraform-oci:v1


#Deploying the vThunders using image built above:

1. docker run -v /path/to/oci/main/new_infra/HA/:/main/new_infra/HA/ -v /home/.ssh/id_rsa.pub:/oci_key.pub -v /home/oci/oci_api_key.pem:/oci_api_key.pem a10/thunder:oci4 apply --auto-approve
