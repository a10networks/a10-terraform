Instructions to play with a10-terraform OCI module:

1.) Clone the repository from git hub:
https://github.com/a10networks/a10-terraform.git

2.) Go to the oci directory in cloned repository and edit the tfvars file to configure all the appropriate parameters:
example:
<>/oci/main/existing_infra/util/terraform.tfvars

3.) In the same "util" directory(containing .tfvars file) simply run the wrapper scripts to spin-up and tear-down OCI instance.

a.) To spin-up the OCI instance, simply run the following wrapper:
bash# ./a10-spin-oci-instance.sh

b.) To tear-down the OCI instance, simply run the following wrapper:
bash# ./a10-tear-down-oci-instance.sh
