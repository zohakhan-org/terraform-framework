#!/bin/bash

CONFIG_FILE="./services-config.yaml"
TFVARS_FILE="./terraform.tfvars"

if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "Services configuration file not found!"
  exit 1
fi

echo "Generating terraform.tfvars..."
# Debugging: Check the contents of the CONFIG_FILE
echo "Checking the contents of $CONFIG_FILE..."
cat "$CONFIG_FILE"

AWS_REGION=$(yq -r '.aws_region' "$CONFIG_FILE")
if [[ -z "$AWS_REGION" ]]; then
  echo "Error: aws_region not defined in $CONFIG_FILE"
  exit 1
fi

# Write aws_region to terraform.tfvars
echo "aws_region = \"$AWS_REGION\"" > "$TFVARS_FILE"


yq e  '.services | keys[]' "$CONFIG_FILE" | while read -r SERVICE; do
  case $SERVICE in
    ecs)
      echo "Adding ECS configuration..."
      ECS_CLUSTER_NAME=$(yq -r '.services.ECS.cluster_name' "$CONFIG_FILE")
      ECS_INSTANCE_TYPE=$(yq -r '.services.ECS.instance_type' "$CONFIG_FILE")
      echo "ecs_cluster_name = \"$ECS_CLUSTER_NAME\"" >> "$TFVARS_FILE"
      echo "ecs_instance_type = \"$ECS_INSTANCE_TYPE\"" >> "$TFVARS_FILE"
      ;;
    s3)
      echo "Adding S3 configuration..."
      S3_BUCKET_NAME=$(yq -r '.services.S3.bucket_name' "$CONFIG_FILE")
      echo "s3_bucket_name = \"$S3_BUCKET_NAME\"" >> "$TFVARS_FILE"
      ;;
    iam)
      echo "Adding IAM configuration..."
      IAM_ROLES=$(yq -r '.services.iam.roles' "$CONFIG_FILE")
      IAM_GROUPS=$(yq -r '.services.iam.groups' "$CONFIG_FILE")
      echo "iam_roles = $IAM_ROLES" >> "$TFVARS_FILE"
      echo "iam_groups = $IAM_GROUPS" >> "$TFVARS_FILE"
      ;;
    *)
      echo "Unknown service: $SERVICE"
      ;;
  esac
done
cat ./terraform.tfvars
echo "Terraform tfvars generated successfully!"
