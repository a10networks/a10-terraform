#!/bin/bash
cd oci-reboot
echo "Rebooting HA pair with IP Following IP addresses" 
echo $1
echo "Deleting Older state files"
rm *.tfstate
terraform init
echo "Terraform Plan for active and standby nodes"
terraform plan -var "vthunder_hostname=vthunder-vm-1" -var "vthunder_public_ip=%1"  -state="vthunder-active.tfstate"
echo "Terraform Apply for active and standby nodes"
terraform apply -var "vthunder_hostname=vthunder-vm-1" -var "vthunder_public_ip=%1" -state="vthunder-active.tfstate" --auto-approve
