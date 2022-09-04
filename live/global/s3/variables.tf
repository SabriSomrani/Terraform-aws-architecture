variable "region" {
  type    = string
  default = "eu-west-1"
}

locals {
  s3_tags = {
    created_by     = "SRE"
    Environment    = terraform.workspace
    CreationMethod = "Terraform"
    Project        = "Academic Tracker"
  }
}
