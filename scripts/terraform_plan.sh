#!/bin/bash

echo "Running Terraform Plan..."
terraform plan -var-file="./terraform.tfvars"
