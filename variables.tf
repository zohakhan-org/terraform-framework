variable "aws_region" {
  type = string
}

variable "iam_roles" {
  type = list(object({
    name     = string
    policies = list(string)
  }))
}

variable "iam_groups" {
  type = list(object({
    name     = string
    policies = list(string)
  }))
}

variable "ecs_cluster_name" {
  type = string
}

variable "ecs_instance_type" {
  type = string
}

variable "s3_bucket_name" {
  type = string
}
