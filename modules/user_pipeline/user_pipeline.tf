resource "aws_iam_user" "pipeline_user" {
  name = var.user_name

  tags = merge(
    var.tags,
    tomap({
      "Name" = var.user_name
    })
  )
}

resource "aws_iam_access_key" "lb" {
  user = aws_iam_user.pipeline_user.name
}
resource "aws_iam_user_policy_attachment" "AmazonEC2ContainerRegistryPowerUser" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
  user       = aws_iam_user.pipeline_user.name
}

resource "aws_iam_user_policy" "user_policy" {
  name = "${var.environment}-${var.user_name}-eks-policy"
  user = aws_iam_user.pipeline_user.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "eks:DescribeNodegroup",
                "eks:ListNodegroups",
                "eks:DescribeCluster",
                "eks:ListClusters",
                "ssm:GetParameter",
                "eks:AccessKubernetesApi"
            ],
            "Resource": "*"
        }
    ]
}

EOF
}


