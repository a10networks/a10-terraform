# TERRAFORM

This project contains examples of how to deploy A10 services with terraform.

## What does this TF script will do:
Terraform script will creste an instance of vThunder with three network interfaces. 

It provides an option to create an instance with already existing infrastructure (existing vpc, subnets, internet gateways, routes, security groups, etc.)

Below are the details for each cloud implementation:

 - AWS:
    - Existing Infrastructure :
     - Instance will be created with already existing infrastructure.
     - Creation of instance requires existing vpc, subnets, security goups, route tables.
     - Script takes input arguments - vpc id, public and private subnet ids and security group id.
     - Module located at - a10-terraform/aws/main/AWS/existing_infra/3NIC/
    
    - Create new infrastructure :
     - Infrastructure will be created from scract in order to create an instance.
     - Creates one custom VPC, inside that VPC it will create one public and private subnet
     - Creates an Internet Gateway and attach it to created custom VPC
     - Creates an vThunder instance with 2 NIC on each subnets
     - Creates 3 Elastic IP's, one for management, one is for Data NIC and another is for VIP
     - Module located at - a10-terraform/aws/main/AWS/standalone/3NIC/

 - OCI:
    - Existing infrastrucutre :
     - Instance will be created with already existing infrastructure.
     - Creation of instance requires existing vcn, subnets, security lists, routes.
     - Script takes input argument - Subnet id.
     - Module located at - a10-terraform/oci/main/existing_infra/OCI/util/
    
    - Create new infrastructure :
     - Infrastructure will be created from scract in order to create an instance.
     - Creates one custom VCN, inside that VPC it will create 3 subnets
     - Creates an Internet Gateway and attach it to created custom VCN
     - Creates 2 vThunder instances with 3 NIC on created subnets.
     - Module located at - a10-terraform/oci/main/singlecloud/OCI/util/


## REQUIREMENTS

The following are general prerequisites for these templates:
 - Credentials in each environment with the appropriate permission to create associated resources.
    * Special Note :
        * For AWS and OCI, the credentials used in the terraform provider must be able to create IAM Instance Profiles.
 - Accepted the EULAProTip! Updating your profile with your name, location, and a profile picture helps other GitHub users get to know you.

 for all images used in the marketplace. If you have not deployed these images in environment before, search for the images in the Marketplace and then click **Accept Software Terms**.  This typically only appears the first time you attempt to launch an image.
    * Images used:
        - **A10 Image used**
            - **AWS**:
                 https://aws.amazon.com/marketplace/pp/B01I9BK4ZW?qid=1560841760149&sr=0-2&ref_=srh_res_product_title
            - **OCI**:
                 https://cloudmarketplace.oracle.com/marketplace/en_US/listing/51617399

 - Key pair for SSH access to instances
    - **aws**: you can create or import the key pair in AWS, see http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html for information.

## Special Note:
    - You need to mention ec2 key pair name in terraform.tfvar of AWS

## USAGE

The most challenging part will be obtaining the necessary credentials for each provider. The templates rely on environmental variables for the provider credentials. See the individual provider for each environment for more details.

https://www.terraform.io/docs/providers/aws/index.html
https://www.terraform.io/docs/providers/oci/index.html

For example, if manually setting environment variables, the file can look like:


```
> cat my-terraform-provider-creds
#!/bin/bash

# AWS CREDENTIALS
export AWS_ACCESS_KEY_ID="XXXXXXXXXXXXXXXXXXX"
export AWS_SECRET_ACCESS_KEY="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
export AWS_DEFAULT_REGION=""eu-west-2"



then before you start, simply run:

```
> source my-terraform-provider-creds
```

Next, as most of the examples leverage modules ( reusable templates ), you must first import or "get" them.

- terraform get
  - In many cases, the modules reference a remote link as the source so internet connectivity will be required.
  - **hint**: use "terraform get -update=true" to make sure your modules are up-to-date

- terraform plan

- terraform apply

- terraform destroy


For more information using terraform, please see:

[Terraform](https://www.terraform.io/)

[Getting Started](https://www.terraform.io/intro/getting-started/install.html)


### QUICK START

```
AWS:

source my-terraform-creds # see above
cd reference/AWS/util
vim terraform.tfvars      # configure any variables required with EC2 key pair name to create instance
terraform get
terraform apply


OCI:

source my-terraform-creds # see above
cd reference/oci/util
vim terraform.tfvars      # configure any variables required
###
Edit this file with your OCI Provider details, Login details, vThunder VM details

terraform get
terraform apply
#at terraform apply it will ask you VM ssh public key file path, enter full absolute path with filename

```

### REFERENCE LINKS

 - https://github.com/hashicorp/best-practices/tree/master/terraform/modules/
 - https://blog.threatstack.com/incorporating-aws-security-best-practices-into-terraform-design
