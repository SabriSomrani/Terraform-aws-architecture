resource "aws_iam_user" "user" {
  name = var.user_name
  path = "/"

  tags = merge(
    var.tags,
    tomap({
      "Name" = var.user_name
    })
  )
}

resource "aws_iam_access_key" "access_key" {
  user = aws_iam_user.user.name
}

resource "aws_iam_user_policy" "user_policy" {
  name = "${var.environment}-athena-bucket-policy"
  user = aws_iam_user.user.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "${var.bucket_arn}/*",
                "${var.bucket_arn}"
            ]
        }
    ]
}
EOF
}
