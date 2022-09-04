resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name         = "academic-tracker-terraform-remote-state-lock"
  hash_key     = var.hash_key
  billing_mode = var.billing_mode
  point_in_time_recovery {
    enabled = true
  }

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = merge(
    local.dynamodb_tags,
    tomap({
      "IsMutualized" = "true"
    })
  )
}


