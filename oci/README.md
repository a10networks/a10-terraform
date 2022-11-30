Instructions to deploy vThunder on OCI:

1) Clone the repository from github location:
https://github.com/a10networks/a10-terraform.git

2) In your cloned repository, go to the oci directory. Now edit the tfvars file to set values for all variables:
Check ../README.md first to know the difference between new_infra and existing_infra then go to corrsponding directory:
 - main/new_infra/util/
 - main/existing_infra/util/

3) To spin-up an OCI instance(s), run the below script:
./a10-spin-oci-instance.sh

4) To tear-down those OCI instance(s), run the below script:
./a10-tear-down-oci-instance.sh

Suggested Terraform version: v0.15.0
