#!/bin/bash

echo "Initializing Terraform..."
terraform init
if [[ $? -ne 0 ]]; then
  echo "Terraform initialization failed!"
  exit 1
fi
echo "Terraform initialization completed."
