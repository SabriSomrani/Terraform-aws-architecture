# -----------------------------------------------------------------------------------------------------------------------
#  IAM Policy for AWS LoadBalancer Controller
# ------------------------------------------------------------------------------------------------------------------------

resource "aws_iam_policy" "policy" {
  name        = var.ingress_policy_name
  path        = "/"
  description = "IAM policy for the AWS Load Balancer Controller"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = var.policy_file

}

# ------------------------------------------------------------------------------------------------------------------------
# IAM Role for AWS LoadBalancer Controller
# ------------------------------------------------------------------------------------------------------------------------

resource "aws_iam_role" "controller_role" {
  name = var.ingress_role_name
  description = "IAM role for the AWS Load Balancer Controller"

  tags = var.tags

  assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::${var.aws_account_id}:oidc-provider/${trim(var.identity_oidc_issuer, "htpps://")}"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "${trim(var.identity_oidc_issuer, "htpps://")}:sub": "system:serviceaccount:kube-system:${var.service_account_name}",
                    "${trim(var.identity_oidc_issuer, "htpps://")}:aud": "sts.amazonaws.com"
}
            }
        }
    ]
}
POLICY
}

# ------------------------------------------------------------------------------------------------------------------------
#  Attach Policy
# ------------------------------------------------------------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "AWSLoadBalancerControllerIAMPolicy" {
  policy_arn = aws_iam_policy.policy.arn
  role       = aws_iam_role.controller_role.name
}

# ------------------------------------------------------------------------------------------------------------------------
#  IAM Openid Connect Provider
# ------------------------------------------------------------------------------------------------------------------------

data "tls_certificate" "tls_certificate" {
  url = var.identity_oidc_issuer
}

resource "aws_iam_openid_connect_provider" "oidc" {
  url = var.identity_oidc_issuer

  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = [data.tls_certificate.tls_certificate.certificates.0.sha1_fingerprint]

  tags = var.tags
}

