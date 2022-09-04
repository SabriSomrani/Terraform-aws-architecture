# -----------------------------------------------------------------------------------------------------------------------
#  ECR
# ------------------------------------------------------------------------------------------------------------------------

resource "aws_ecr_repository" "ecr_repo" {
  name                 = var.ecr_repository
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = merge(
    var.tags,
    tomap({ "Name" = var.ecr_repository}
    )
  )
}
