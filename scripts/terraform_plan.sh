#!/bin/bash

echo "Running Terraform Plan..."
ls -lrt
terraform plan -var-file="./terraform.tfvars"
