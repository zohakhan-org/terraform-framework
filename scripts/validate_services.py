import sys
import yaml

def validate_services(input_services, config_file="service-config.yaml"):
    try:
        with open(config_file, "r") as file:
            config = yaml.safe_load(file)
            available_services = config.get("services", {}).keys()

        invalid_services = [s for s in input_services if s not in available_services]

        if invalid_services:
            print(f"Invalid services: {', '.join(invalid_services)}")
            sys.exit(1)

        print("All services are valid!")
    except FileNotFoundError:
        print(f"Configuration file {config_file} not found.")
        sys.exit(1)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python validate_services.py <comma-separated-services>")
        sys.exit(1)

    services = sys.argv[1].split(",")
    validate_services(services)
