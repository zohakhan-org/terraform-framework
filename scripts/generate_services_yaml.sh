#!/bin/bash

SERVICES_INPUT=$1
CONFIG_FILE="service-config.yaml"
OUTPUT_FILE="services_to_deploy.yaml"

if [[ -z "$SERVICES_INPUT" ]]; then
  echo "No services specified for deployment!"
  exit 1
fi

echo "Generating services_to_deploy.yaml..."
echo "services:" > "$OUTPUT_FILE"

for SERVICE in $(echo "$SERVICES_INPUT" | tr ',' ' '); do
  echo "- $SERVICE" >> "$OUTPUT_FILE"
done

echo "services_to_deploy.yaml generated successfully!"
