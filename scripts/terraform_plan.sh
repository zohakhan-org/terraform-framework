#!/bin/bash
echo "Running Terraform Plan..."
ls -lrt
echo "services configuration "
cat services-config.yaml
echo "services to be deployed "
cat services_to_deploy.yaml
echo "terraform.tfvar file"
cat terraform.tfvars

SERVICES_FILE="./services_to_deploy.yaml"
# Path to the services configuration file or tfvars file
TFVARS_FILE="./terraform.tfvars"

# Path to the root module or module directories
MODULES_DIR="./modules"

if [[ ! -f "$SERVICES_FILE" ]]; then
  echo "Error: $SERVICES_FILE not found!"
  exit 1
fi

# Read the services to deploy from the YAML file using yq
SELECTED_SERVICES=$(yq -r '.services[]' "$SERVICES_FILE")

# Initialize Terraform (only once for all modules)
terraform init

# Iterate over the selected services and call the corresponding modules
for SERVICE in $SELECTED_SERVICES; do
  case "$SERVICE" in
    "ecs")
      echo "Deploying ECS service..."
      terraform plan -var-file="$TFVARS_FILE" -chdir="$MODULES_DIR/ecs" -target=module.ecs
      terraform apply -var-file="$TFVARS_FILE" -chdir="$MODULES_DIR/ecs" -target=module.ecs
      ;;
    "iam")
      echo "Deploying IAM service..."
      terraform plan -var-file="$TFVARS_FILE" -chdir="$MODULES_DIR/iam" -target=module.iam
      terraform apply -var-file="$TFVARS_FILE" -chdir="$MODULES_DIR/iam" -target=module.iam
      ;;
    "s3")
      echo "Deploying S3 service..."
      terraform plan -var-file="$TFVARS_FILE" -chdir="$MODULES_DIR/iam" -target=module.s3
      terraform apply -var-file="$TFVARS_FILE" -chdir="$MODULES_DIR/iam" -target=module.s3
      ;;
    *)
      echo "Unknown service: $SERVICE"
      ;;
  esac
done
