output "user_arn" {
  value = aws_iam_user.pipeline_user.arn
}

output "user_name" {
  value = aws_iam_user.pipeline_user.name
}
