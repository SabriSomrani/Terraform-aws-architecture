terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.0"
    }
  }
  /*  backend "s3" {
    bucket                  = "academic-tracker-terraform-remote-s3-state"
    dynamodb_table          = "academic-tracker-terraform-remote-state-lock"
    key                     = "terraform"
    region                  = "eu-west-1"
    encrypt                 = true
    shared_credentials_file = "~/.aws/credentials"
    profile                 = "athena"
  } */
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile

}

data "aws_eks_cluster_auth" "cluster_auth" {
  name = module.eks_cluster.cluster_name
}

 provider "helm" {
   kubernetes {
     host                   = module.eks_cluster.eks_cluster_endpoint
     cluster_ca_certificate = base64decode(module.eks_cluster.certificate_authority)
     token                  = data.aws_eks_cluster_auth.cluster_auth.token
   }
 }
provider "kubernetes" {
     host                   = module.eks_cluster.eks_cluster_endpoint
     cluster_ca_certificate = base64decode(module.eks_cluster.certificate_authority)
     token                  = data.aws_eks_cluster_auth.cluster_auth.token
}


