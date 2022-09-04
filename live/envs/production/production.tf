module "s3-bucket" {
  source          = "../../../modules/s3"
  bucket_name     = "${var.environment}-athena-files"
  environment     = var.environment
  tags            = local.common_tags
  expiration_days = var.expirations_days
}

module "iam_user" {
  source      = "../../../modules/iam_user"
  user_name   = "${var.environment}-athena-bucket-user"
  environment = var.environment
  tags        = local.common_tags
  bucket_arn  = module.s3-bucket.bucket_arn
}

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
  source                 = "../../../modules/eks"
  cluster_name           = "${var.environment}-eks-cluster"
  subnets_ids            = module.vpc.private_subnets
  tags                   = local.common_tags
  role_arn               = module.eks_role.eks_role_arn
  node_group_name        = "${var.environment}-eks-node-group"
  node_role_name         = module.eks_role.node_role_arn
  desired_size           = var.eks_scaling_config.desired_size
  max_size               = var.eks_scaling_config.max_size
  min_size               = var.eks_scaling_config.min_size
  update_max_unavailable = var.update_ng_max_unavailable
  node_instance_type     = var.node_instance_type
  source_sg_id           = [module.bastion.sg_id]
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

module "controller_policy" {
  source = "../../../modules/eks/iam_alb_controller"
  ingress_policy_name = "${var.environment}-AWSLoadBalancerControllerIAMPolicy"
  policy_file = file("../../../modules/iam/iam_alb_controller/templates/iam_policy.json")
  aws_account_id = var.aws_account_id
  identity_oidc_issuer = module.eks_cluster.identity_oidc_issuer
  ingress_role_name = "${var.environment}-${var.ingress_role_name}"
  tags = local.common_tags
  service_account_name = var.service_account_name
}

module "alb_controller" {
  source = "../../../modules/eks/alb_controller"
  aws_account_id = var.aws_account_id
  ingress_role_name = "${var.environment}-${var.ingress_role_name}"
  cluster_name = "${var.environment}-${var.cluster_name}"
  service_account_name = var.service_account_name
}
