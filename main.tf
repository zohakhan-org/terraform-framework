terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  services_to_deploy = jsondecode(file("${path.module}/services_to_deploy.json"))
}

# Dynamically include IAM module
module "iam" {
  source  = "./modules/iam"
  for_each = toset(contains(local.services_to_deploy, "iam") ? ["iam"] : [])
  roles   = var.iam_roles
  groups  = var.iam_groups
}

# Dynamically include ECS module
module "ecs" {
  source        = "./modules/ecs"
  for_each      = toset(contains(local.services_to_deploy, "ecs") ? ["ecs"] : [])
  cluster_name  = var.ecs_cluster_name
  instance_type = var.ecs_instance_type
}

# Dynamically include S3 module
module "s3" {
  source      = "./modules/s3"
  for_each    = toset(contains(local.services_to_deploy, "s3") ? ["s3"] : [])
  bucket_name = var.s3_bucket_name
}
