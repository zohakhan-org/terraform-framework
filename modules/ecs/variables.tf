# ecs/variables.tf
variable "ecs_cluster_name" {
  description = "The name of the ECS cluster."
  type        = string
}

variable "ecs_instance_type" {
  description = "The instance type for the ECS instances."
  type        = string
}
