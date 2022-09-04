output "eks_role_arn" {
  value = aws_iam_role.eks_role.arn
}
output "node_role_arn" {
  value = aws_iam_role.eks_nodes_role.arn
}
