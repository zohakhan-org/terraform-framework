#!/bin/bash
echo "Running Terraform Plan..."
pwd
ls -lrt
echo "services configuration "
cat services-config.yaml
echo "services to be deployed "
cat services_to_deploy.yaml
echo "terraform.tfvars file"
cat terraform.tfvars

SERVICES_FILE="services_to_deploy.yaml"
# Path to the services configuration file or tfvars file
TFVARS_FILE="terraform.tfvars"


# Path to the root module or module directories
MODULES_DIR="modules"

if [[ ! -f "$SERVICES_FILE" ]]; then
  echo "Error: $SERVICES_FILE not found!"
  exit 1
fi

# Read the services to deploy from the YAML file using yq
SELECTED_SERVICES=$(yq -r '.services[]' "$SERVICES_FILE")


# Iterate over the selected services and call the corresponding modules
for SERVICE in $SELECTED_SERVICES; do

    MODULE_PATH="$MODULES_DIR/$SERVICE"

    # Ensure the module directory exists
    if [[ ! -d "$MODULE_PATH" ]]; then
      echo "Error: Module directory $MODULE_PATH not found!"
      exit 1
    fi

    case "$SERVICE" in
    "ecs")
      echo "Deploying ECS service..."
      chmod +r terraform.tfvars
      cp terraform.tfvars "$MODULE_PATH/"
      echo "Terraform Validate"
      terraform -chdir="$MODULE_PATH" validate
      echo "terraform plan"
      ls -lrt
      terraform -chdir="$MODULE_PATH" plan  -var-file="$TFVARS_FILE"  -target=modules.ecs
      echo "Terraform apply"

      terraform -chdir="$MODULE_PATH" apply -var-file="$TFVARS_FILE"  -target=modules.ecs
      cd - || exit
      ;;
    "iam")
      echo "Deploying IAM service..."
      chmod +r terraform.tfvars
      cp terraform.tfvars "$MODULE_PATH/"
      terraform -chdir="$MODULE_PATH" init
      echo "Terraform Validate"
      terraform -chdir="$MODULE_PATH" validate
      echo "terraform plan"
      ls -lrt "$MODULE_PATH"
      cat "$TFVARS_FILE" && terraform -chdir="$MODULE_PATH" plan  -var-file="$TFVARS_FILE"  -target=modules.iam
      echo "Terraform apply"
      terraform -chdir="$MODULE_PATH" apply -var-file="$TFVARS_FILE" -target=modules.iam
      cd - || exit
      ;;
    "s3")
      echo "Deploying S3 service..."
      chmod +r terraform.tfvars
      echo "Terraform Validate"
      terraform -chdir="$MODULE_PATH" validate
      echo "terraform plan"
      ls -lrt
      terraform  -chdir="$MODULE_PATH" plan -var-file="$TFVARS_FILE" -target=modules.s3
      echo "Terraform apply"
      terraform  -chdir="$MODULE_PATH" apply -var-file="$TFVARS_FILE" -target=modules.s3
      cd - || exit
      ;;
    *)
      echo "Unknown service: $SERVICE"
      ;;
  esac
done


