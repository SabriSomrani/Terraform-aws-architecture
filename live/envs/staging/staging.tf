# module "s3-bucket" {
#  source          = "../../../modules/s3"
#  bucket_name     = "s${var.environment}-athena-files"
#  environment     = var.environment
#  tags            = local.common_tags
#  expiration_days = var.expirations_days
#}
#
#module "iam_user" {
#  source      = "../../../modules/iam_user"
#  user_name   = "${var.environment}-athena-user"
#  environment = var.environment
#  tags        = local.common_tags
#  bucket_arn  = module.s3-bucket.bucket_arn
#}

module "user_pipeline" {
  source      = "../../../modules/user_pipeline"
  environment = var.environment
  tags        = local.common_tags
  user_name   = var.user_name
}

#module "ecr" {
#  source = "../../../modules/ecr"
#  ecr_repository = "academic"
#  tags = local.common_tags
#}


module "vpc" {
  source             = "../../../modules/vpc"
  availability_zones = var.availability_zones
  cidr_block         = var.cidr_block
  database_subnets   = var.database_subnets
  env                = var.environment
  nat_gateway_count  = var.nat_gateway_count
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  tags               = local.common_tags
}

module "eks_role" {
  source            = "../../../modules/eks/iam_eks"
  cluster_role_name = "${var.environment}-eks-cluster-role"
  nodes_role_name   = "${var.environment}-eks-nodes-role"
  tags              = local.common_tags
}


module "eks_cluster" {
  source             = "../../../modules/eks/eks_cluster"
  cluster_name       = "${var.environment}-eks-cluster"
  desired_size       = var.eks_scaling_config.desired_size
  ingress_role_arn   = module.iam_alb_controller.ingress_role_arn
  max_size           = var.eks_scaling_config.max_size
  min_size           = var.eks_scaling_config.min_size
  node_group_name    = "${var.environment}-eks-nodes-group"
  node_instance_type = var.node_instance_type
  node_role_arn      = module.eks_role.node_role_arn
  role_arn           = module.eks_role.eks_role_arn
  subnets_ids            = module.vpc.private_subnets
#  subnets_ids            = ["subnet-0f93e87ced05774ab", "subnet-02cc4171ca9720482", "subnet-06fa408e609c23e78"]
  tags                   = local.common_tags
  update_max_unavailable = var.update_ng_max_unavailable
  user_arn               = module.user_pipeline.user_arn
  user_name              = module.user_pipeline.user_name
}

module "iam_alb_controller" {
  source               = "../../../modules/eks/iam_alb_controller"
  aws_account_id       = var.aws_account_id
  identity_oidc_issuer = module.eks_cluster.identity_oidc_issuer
  ingress_policy_name  = "${var.environment}-alb-policy"
  ingress_role_name    = "${var.environment}-alb-role"
  policy_file          = file("../../../modules/eks/iam_alb_controller/templates/iam_policy.json")
  service_account_name = var.service_account_name
  tags                 = local.common_tags
}

module "rbac" {
  source            = "../../../modules/eks/k8s_RBAC"
  user_name         = var.user_name
  namespace         = "academic-tracker"
  rbac_resources    = ["*"]
  rbac_verbs        = ["*"]
  role_binding_name = "${var.environment}-role-binding"
  role_name         = "${var.environment}-role"
}


module "bastion" {
  source               = "../../../modules/ec2"
  associate_public_ip  = true
  desired_capacity     = var.bastion_asg_config.desired_capacity
  enable_monitoring    = false
  env                  = var.environment
  health_check_type    = "EC2"
  iam_instance_profile = ""
  instance_type        = var.bastion_instance_type
  max_size             = var.bastion_asg_config.max_size
  min_size             = var.bastion_asg_config.min_size
  name                 = "${var.environment}-Bastion-host"
  subnets              = module.vpc.public_subnets
  tags                 = local.common_tags
  user_data            = ""
  vpc_id               = module.vpc.vpc_id
}


module "alb_controller" {
  source               = "../../../modules/eks/alb_controller"
  cluster_name         = module.eks_cluster.cluster_name
  ingress_role_arn     = module.iam_alb_controller.ingress_role_arn
  service_account_name = var.service_account_name
}

