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
    cp terraform.tfvars "$MODULE_PATH/"
    # Ensure the module directory exists
    if [[ ! -d "$MODULE_PATH" ]]; then
      echo "Error: Module directory $MODULE_PATH not found!"
      exit 1
    fi
    terraform -chdir="$MODULE_PATH" init
    case "$SERVICE" in
    "ecs")
      echo "Deploying ECS service..."
      #chmod +r terraform.tfvars
      echo "Terraform Validate"
      terraform -chdir="$MODULE_PATH" validate
      echo "terraform plan"

      terraform -chdir="$MODULE_PATH" plan  -var-file="$TFVARS_FILE"  -target=module.ecs
      echo "Terraform apply"

      terraform -chdir="$MODULE_PATH" apply -var-file="$TFVARS_FILE"  -target=module.ecs
      cd - || exit
      ;;
    "iam")
      echo "Deploying IAM service..."
      chmod +r terraform.tfvars
      terraform -chdir="$MODULE_PATH" plan  -var-file="$TFVARS_FILE"  -target=module.iam
      terraform -chdir="$MODULE_PATH" apply -var-file="$TFVARS_FILE" -target=module.iam
      cd - || exit
      ;;
    "s3")
      echo "Deploying S3 service..."
      chmod +r terraform.tfvars
      terraform  -chdir="$MODULE_PATH" plan -var-file="$TFVARS_FILE" -target=module.s3
      terraform  -chdir="$MODULE_PATH" apply -var-file="$TFVARS_FILE" -target=module.s3
      cd - || exit
      ;;
    *)
      echo "Unknown service: $SERVICE"
      ;;
  esac
done


