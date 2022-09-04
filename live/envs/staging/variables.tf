
variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "aws_profile" {
  type    = string
  default = "athena"
}
variable "aws_account_id" {
  type    = string
  default = "1111222233333"
}

variable "environment" {
  type    = string
  default = "Staging"
}

variable "cidr_block" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "0.0.0.0/0"
}

variable "availability_zones" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = []
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}
variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}
variable "database_subnets" {
  description = "A list of database subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "nat_gateway_count" {
  description = "Number of Nat Gateway"
  type        = number
  default     = "1"
}

variable "expirations_days" {
  type    = number
  default = 1
}

variable "eks_scaling_config" {
  description = "scaling configuration for eks group nodes"
  type        = map(number)
  default     = { desired_size = 1, max_size = 1, min_size = 1 }
}

variable "update_ng_max_unavailable" {
  description = "max unavailable instance when updates"
  type        = number
  default     = 1
}
variable "node_instance_type" {
  description = "type of instances node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "bastion_asg_config" {
  description = "autoscaling group configuration"
  type        = map(string)
  default     = { "desired_capacity" : 0, "max_size" : 0, "min_size" : 0 }
}


variable "bastion_instance_type" {
  description = "type instance of bastion host"
  type        = string
  default     = "t2.micro"
}
variable "cluster_name" {
  type    = string
  default = "eks-cluster"
}

variable "ingress_role_name" {
  type    = string
  default = "AmazonEKSLoadBalancerControllerRole"
}
variable "service_account_name" {
  type    = string
  default = "aws-load-balancer-controller"
}

variable "user_name" {
  description = "user pipeline name"
  type        = string
  default     = "user-pipline"
}

locals {
  common_tags = {
    created_by     = "SRE"
    Environment    = terraform.workspace
    CreationMethod = "Terraform"
    Project        = "Academic Tracker"
  }
}


