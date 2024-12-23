#!/bin/bash

CONFIG_FILE="./services_to_deploy.yaml"
OUTPUT_FILE="./services_to_deploy.json"

if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "Error: $CONFIG_FILE not found!"
  exit 1
fi

yq -o=json -I=0 ".services" "$CONFIG_FILE" > "$OUTPUT_FILE"

echo "Generated $OUTPUT_FILE successfully."
