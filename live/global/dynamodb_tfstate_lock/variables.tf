variable "region" {
  default = "eu-west-1"
}
variable "hash_key" {
  default = "LockID"
}
variable "billing_mode" {
  default = "PAY_PER_REQUEST"
}


locals {
  dynamodb_tags = {
    created_by     = "SRE"
    Environment    = terraform.workspace
    CreationMethod = "Terraform"
    Project        = "Academic Tracker"
  }
}

