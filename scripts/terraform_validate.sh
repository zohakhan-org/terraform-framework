#!/bin/bash

echo "Validating Terraform configuration..."
terraform validate
if [[ $? -ne 0 ]]; then
  echo "Terraform validation failed!"
  exit 1
fi
echo "Terraform validation completed."
