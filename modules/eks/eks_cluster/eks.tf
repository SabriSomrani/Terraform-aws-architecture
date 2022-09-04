# ---------------------------------------------------------------------------------------------------------------------
# Key pair generation (store it as SSM parameter and locally)
# ---------------------------------------------------------------------------------------------------------------------
resource "tls_private_key" "generated" {
  algorithm = "RSA"
  rsa_bits  = 4096

}
resource "aws_key_pair" "generated" {
  key_name   = var.node_group_name
  depends_on = [tls_private_key.generated]
  public_key = tls_private_key.generated.public_key_openssh
}
resource "aws_ssm_parameter" "key_pair" {
  name      = "${var.node_group_name}-key-pair"
  value     = tls_private_key.generated.private_key_pem
  type      = "SecureString"
  overwrite = true
}

# ----------------------------------------------------------------------------------------------------------------------
#  EKS Cluster
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  role_arn = var.role_arn

  vpc_config {
    subnet_ids = var.subnets_ids
  }

  tags = merge(
    var.tags,
    tomap({
      "Name" = var.cluster_name
    })
  )
}

# -----------------------------------------------------------------------------------------------------------------------
# Kubernetes ConfigMap for Additional User
# -----------------------------------------------------------------------------------------------------------------------

resource "kubernetes_config_map" "aws-auth" {
  data = {
    "mapRoles" = <<EOT
  - rolearn: ${var.ingress_role_arn}
    username: ${var.user_name}
    groups:
    - system:masters
EOT
    "mapUsers" = <<EOT
  - userarn: ${var.user_arn}
    username: ${var.user_name}
    groups: [""]

EOT
  }
  lifecycle {
       create_before_destroy = false
       ignore_changes        = [ data["mapRoles"]]
   }

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  depends_on = [aws_eks_cluster.eks_cluster]
}

# ----------------------------------------------------------------------------------------------------------------------
# EKS Node Group
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_eks_node_group" "node" {
  cluster_name           = aws_eks_cluster.eks_cluster.name
  node_group_name_prefix = var.node_group_name
  node_role_arn          = var.node_role_arn
  subnet_ids             = var.subnets_ids
  instance_types         = var.node_instance_type

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  update_config {
    max_unavailable = var.update_max_unavailable
  }

#  remote_access {
#    ec2_ssh_key               = aws_key_pair.generated.key_name
#    source_security_group_ids = var.source_sg_id
#  }

  tags = merge(
    var.tags,
    tomap({
      "Name"                = var.node_group_name,
      "propagate_at_launch" = true
    })
  )

   depends_on = [kubernetes_config_map.aws-auth]
}









