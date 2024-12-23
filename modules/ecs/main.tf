# modules/ecs/main.tf
resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.ecs_cluster_name
}

resource "aws_instance" "ecs_instance" {
  instance_type = var.ecs_instance_type
  ami           = var.ami
  # other configurations
}

