#!/bin/bash

CONFIG_FILE="./services-config.yaml"
TFVARS_FILE="./terraform.tfvars"
SELECTED_SERVICES="${SELECTED_SERVICES}"

if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "Services configuration file not found!"
  exit 1
fi

if [[ -z "$SELECTED_SERVICES" ]]; then
  echo "Error: No services selected. Please define SELECTED_SERVICES as a comma-separated list."
  exit 1
fi


echo "Generating terraform.tfvars..."
# Debugging: Check the contents of the CONFIG_FILE
echo "Checking the contents of $CONFIG_FILE..."
cat "$CONFIG_FILE"

# Extract region from the config file
#AWS_REGION=$(grep '^aws_region:' "$CONFIG_FILE" | awk -F': ' '{print $2}' | tr -d '\"')

AWS_REGION=$(yq -r '.aws_region' "$CONFIG_FILE")

if [[ -z "$AWS_REGION" ]]; then
  echo "Error: AWS Region is not defined in the configuration file."
  exit 1
fi
echo "aws_region = \"$AWS_REGION\"" >> "$TFVARS_FILE"

# Convert SELECTED_SERVICES to an array
IFS=',' read -r -a SERVICES_ARRAY <<< "$SELECTED_SERVICES"
# Iterate through the selected services
for SERVICE in "${SERVICES_ARRAY[@]}"; do
  case $SERVICE in
    ecs)
      echo "Adding ECS configuration..."
      ECS_CLUSTER_NAME=$(yq -r '.services.ecs.cluster_name // "default-cluster"' "$CONFIG_FILE")
      ECS_INSTANCE_TYPE=$(yq -r '.services.ecs.instance_type // "t3.micro"' "$CONFIG_FILE")
      echo "ecs_cluster_name = \"$ECS_CLUSTER_NAME\"" >> "$TFVARS_FILE"
      echo "ecs_instance_type = \"$ECS_INSTANCE_TYPE\"" >> "$TFVARS_FILE"
      ;;
    s3)
      echo "Adding S3 configuration..."
      S3_BUCKET_NAME=$(yq -r '.services.s3.bucket_name // "default-bucket"' "$CONFIG_FILE")
      echo "s3_bucket_name = \"$S3_BUCKET_NAME\"" >> "$TFVARS_FILE"
      ;;
    iam)
      echo "Adding IAM configuration..."
      IAM_ROLES=$(yq -c '.services.iam.roles // []' "$CONFIG_FILE")
      IAM_GROUPS=$(yq -c '.services.iam.groups // []' "$CONFIG_FILE")
      echo "iam_roles = $IAM_ROLES" >> "$TFVARS_FILE"
      echo "iam_groups = $IAM_GROUPS" >> "$TFVARS_FILE"
      ;;
    *)
      echo "Unknown service: $SERVICE"
      ;;
  esac
done

# Debugging: Display the generated terraform.tfvars
cat "$TFVARS_FILE"
echo "Terraform tfvars generated successfully!"
