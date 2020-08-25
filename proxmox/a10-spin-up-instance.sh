#!/bin/bash
terraform init
terraform plan -var-file=small_profile.tfvars
terraform apply -var-file=small_profile.tfvars --auto-approve
