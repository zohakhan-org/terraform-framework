#!/bin/bash

echo "Running Terraform Plan..."
ls -lrt
cat services-config.yaml
cat services_to_deploy.yaml
cat terraform.tfvars
terraform plan -var-file="terraform.tfvars"
