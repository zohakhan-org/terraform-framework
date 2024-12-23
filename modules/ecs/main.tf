resource "aws_ecs_cluster" "ecs_cluster" {
  name = "example-cluster"
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.ecs_cluster.name
}
