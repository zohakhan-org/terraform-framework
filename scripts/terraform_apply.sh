#!/bin/bash

TFVARS_FILE="terraform.tfvars"

echo "Applying Terraform configuration..."
terraform apply -var-file="$TFVARS_FILE" -auto-approve
if [[ $? -ne 0 ]]; then
  echo "Terraform apply failed!"
  exit 1
fi
echo "Terraform apply completed."
