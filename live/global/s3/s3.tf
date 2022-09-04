
resource "aws_s3_bucket" "main" {
  bucket = "academic-tracker-terraform-remote-s3-state"
  acl    = "private"
  tags   = local.s3_tags

  lifecycle {
    prevent_destroy = "true"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = "true"
  }
  lifecycle_rule {
    id      = "state"
    prefix  = "state/"
    enabled = true
    noncurrent_version_expiration {
      days = 90
    }
  }

}
