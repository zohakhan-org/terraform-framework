resource "aws_s3_bucket" "bucket" {
  bucket = "example-s3-bucket"
  acl    = "private"
}

output "s3_bucket_name" {
  value = aws_s3_bucket.bucket.id
}
