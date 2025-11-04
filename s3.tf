resource "aws_s3_bucket" "static_bucket" {
  bucket        = "${var.name_prefix}-${var.bucket_name}"
  force_destroy = true
  tags = {
    Name = "${var.name_prefix}-${var.bucket_name}"
  }
}