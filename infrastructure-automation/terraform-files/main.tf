resource "aws_s3_bucket" "sample_bucket" {

  bucket = lower(var.bucket_name)

  tags = {
    Name        = var.bucket_name
    ManagedBy   = "Terraform"
  }
}