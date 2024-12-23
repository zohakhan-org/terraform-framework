#!/bin/bash

TFVARS_FILE="./terraform.tfvars"

echo "Destroying Terraform infrastructure..."
terraform destroy -var-file="$TFVARS_FILE" -auto-approve
if [[ $? -ne 0 ]]; then
  echo "Terraform destroy failed!"
  exit 1
fi
echo "Terraform destroy completed."
