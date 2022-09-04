resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name

  tags = merge(
    var.tags,
    tomap({
      "Name" = var.bucket_name
    })
  )
}

resource "aws_s3_bucket_lifecycle_configuration" "bucket_lifecycle_config" {
  bucket = aws_s3_bucket.bucket.bucket

  rule {
    id = "delete-files-older-than-${var.expiration_days}-day"

    expiration {
      days = var.expiration_days
    }
    status = "Enabled"
  }
}
