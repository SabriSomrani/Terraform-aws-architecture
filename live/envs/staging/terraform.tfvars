
aws_region     = "us-east-1"
aws_profile    = "athena"
environment    = "Staging"
aws_account_id = "559701111920"

availability_zones = ["us-east-1a", "us-east-1b"]
cidr_block         = "10.0.0.0/16"
public_subnets     = ["10.0.0.0/24", "10.0.1.0/24"]
private_subnets    = ["10.0.2.0/24", "10.0.3.0/24"]
database_subnets   = ["10.0.4.0/24", "10.0.5.0/24"]
nat_gateway_count  = 1

expirations_days = 1

eks_scaling_config = {
  desired_size = 1
  max_size     = 1
  min_size     = 1
}
update_ng_max_unavailable = 1
node_instance_type        = ["t3.medium"]

bastion_asg_config = {
  desired_capacity = 1
  max_size         = 1
  min_size         = 1
}

user_name = "user-pipeline"


bastion_instance_type = "t2.micro"

