resource "aws_db_instance" "db" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  name                 = "exampledb"
  username             = "admin"
  password             = "password"
  skip_final_snapshot  = true
}

output "rds_endpoint" {
  value = aws_db_instance.db.endpoint
}
