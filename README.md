# TERRAFORM

This project contains examples to deploy A10 ADC services with Terraform.

## Purpose of the Terraform script:
The Terraform script provided creates an instance of vThunder with three network interfaces on a cloud provider.
It supports AWS and OCI clouds.

The Terraform script also provides an option to create an instance within an existing infrastructure (for example, existing VPC, subnets, internet gateways, routes, security groups, etc.)

Cloud specific details are mentioned below:

 - AWS:
    - Existing Infrastructure :
       * Instance is created within an already existing infrastructure.
       * Creation of instance requires existing VPC, subnets, security groups, route tables.
       * The Script accepts input arguments for- vpc id, public and private subnet ids and security group id.
       * The module is located at - a10-terraform/aws/main/AWS/existing_infra/3NIC/


   - New infrastructure :
     * Infrastructure is provisioned from scratch to create an instance.
     * Custom VPC is created, within the VPC, one public and one private subnet is provisioned.
     * An Internet Gateway is provisioned and attached to the custom VPC
     * A vThunder instance is provisioned with two NICs on each subnets
     * Three elastic IP's are provisioned, one for management, one for Data NIC and one for VIP.
     * The module is located at - a10-terraform/aws/main/AWS/new_infra/3NIC/

 - OCI:
    - Existing infrastructure :
       * Instance is created within an already existing infrastructure.
       * Creation of instance requires existing vcn, subnets, security lists and routes.
       * The script accepts input argument - subnet id.
       * The module is located at - a10-terraform/oci/main/existing_infra/OCI/util/

    - New infrastructure :
       * Infrastructure is created from scratch to create an instance.
       * One custom VCN is provisioned. Within the VCN, three subnets are provisioned.
       * An Internet Gateway is provisioned and attached to the custom VCN
       * Two vThunder instances are provisioned with three NICs on those subnets.
       * The module is located at - a10-terraform/oci/main/new_infra/OCI/util/


## REQUIREMENTS

General prerequisites for the templates are mentioned as below:
 - Credentials in each environment with associated privileges for resources creation.
    * Note :
        * For AWS and OCI, the credentials provided in the Terraform provider must be able to create IAM Instance Profiles.
 - Accept the EULAProTip! Updating the profile with your name, location, and a profile picture helps other GitHub users to get to know you.

 For all images used in the marketplace
 If these images are not deployed in the environment before, search for the images in the marketplace and click **Accept Software Terms**.  This appears the first time an image is launched.
    
# A10 images used:
- **AWS**:
                 https://aws.amazon.com/marketplace/pp/B01I9BK4ZW?qid=1560841760149&sr=0-2&ref_=srh_res_product_title
- **OCI**:
                 https://cloudmarketplace.oracle.com/marketplace/en_US/listing/51617399

 - Key pair for SSH access to instances
    - **AWS**: Create or import the key pair in AWS. For more information, see   http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html

## Note:
- Mention ec2 key pair name in terraform.tfvar of AWS
- Provide all necessary parameters in terraform.tfvar file placed in each relevant folder in the ‘main’ directory.
- Each cloud implementation contains two directories
   - Module: It contains the scripts to be used by main Terraform script
   - Main: This is the entry point. Run the Terraform commands from this directory.


## USAGE

The most important step is getting the necessary credentials for each provider. The templates rely on environmental variables for the provider credentials. For details, see the individual provider for each environment on the links mentioned below.

https://www.terraform.io/docs/providers/aws/index.html
https://www.terraform.io/docs/providers/oci/index.html

For example, if the environment variables are set manually, the file may look like:

```
> cat my-terraform-provider-creds
#!/bin/bash

# AWS CREDENTIALS
export AWS_ACCESS_KEY_ID="XXXXXXXXXXXXXXXXXXX"
export AWS_SECRET_ACCESS_KEY="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
export AWS_DEFAULT_REGION=""eu-west-2"
```

Before starting the process, run the following command:

```
source my-terraform-provider-creds
```
As most of the examples leverage modules ( reusable templates ), first import or "get" them.
- terraform get
  - In many cases, the modules refer a remote link as the source. Therefore, internet connectivity will be required.
  - **hint**: use below command to make sure your modules are up-to-date.
            ```
            terraform get -update=true" 
            ```

- terraform plan

- terraform apply

- terraform destroy


For more information using terraform, see:

[Terraform](https://www.terraform.io/)

[Getting Started](https://www.terraform.io/intro/getting-started/install.html)


### QUICK START

# AWS:

```
source my-terraform-creds # see above
cd reference/AWS/util
vim terraform.tfvars      # configure any variables required with EC2 key pair name to create instance
terraform get
terraform apply
```

# OCI:

```
source my-terraform-creds # see above
cd reference/oci/util
vim terraform.tfvars      # configure any variables required, Edit this file with the OCI Provider details, Login details, vThunder VM details

terraform get
terraform apply           #at terraform apply it will ask you VM ssh public key file path, enter full absolute path with filename

```

### REFERENCE LINKS

 - https://github.com/hashicorp/best-practices/tree/master/terraform/modules/
 - https://blog.threatstack.com/incorporating-aws-security-best-practices-into-terraform-design



## Samples

'terraform.tfvar' file contains sample values for each parameter.

## Bug Reporting and Feature Requests

Please submit bug reports and feature requests via GitHub issues. When reporting bugs, please include the Terraform script that demonstrates the bug and the output. Stack traces are always nice. Ensure that any sensitive information is redacted as Issues, and Pull Requests are publicly viewable.

## Contact

If you have a question that cannot be submitted via GitHub Issues, email support@a10networks.com with "a10-terraform" in the subject line.
