# modules/ecs/main.tf
resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.ecs_cluster_name
}

resource "aws_instance" "ecs_instance" {
  instance_type = var.ecs_instance_type
  # other configurations
}

resource "aws_instance" "ecs_instance" {
  ami           = var.ami
  instance_type = var.instance_type
  # Add other necessary attributes here
}
