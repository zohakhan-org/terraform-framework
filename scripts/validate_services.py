import sys
import yaml
import os


def load_config():
    # Adjust path based on where the script is executed
    config_path = os.path.join(os.path.dirname(__file__), './services-config.yaml')

    if not os.path.exists(config_path):
        print(f"Error: Configuration file {config_path} not found.")
        exit(1)

    with open(config_path, 'r') as file:
        config = yaml.safe_load(file)
    config_services = [service.lower() for service in config.get('services', [])]

    return config


def validate_services_to_deploy(services_to_deploy_file):
    if not os.path.exists(services_to_deploy_file):
        print(f"Error: services_to_deploy.yaml not found at {services_to_deploy_file}.")
        exit(1)

    with open(services_to_deploy_file, 'r') as file:
        services_to_deploy = yaml.safe_load(file)
    services_to_deploy_list = [service.lower() for service in services_to_deploy.get('services', [])]

    # Perform validation logic here, compare services in the two files
    config = load_config()
    services_in_config = config.get('services', [])
    services_in_deploy = services_to_deploy.get('services', [])

    for service in services_in_deploy:
        if service not in services_in_config:
            print(f"Error: Service {service} is not defined in services-config.yaml.")
            exit(1)

    print("Services validation passed.")


if __name__ == '__main__':
    services_to_deploy_file = 'services_to_deploy.yaml'  # Path to the generated file
    validate_services_to_deploy(services_to_deploy_file)