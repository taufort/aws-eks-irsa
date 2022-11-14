locals {
  eks_oidc_issuer_url = "https://${module.eks_blueprints.eks_oidc_issuer_url}"
}

# NOTE: Those two resources can be created through the AWS EKS bluprints with 'enable_irsa' parameter
# I chose to create them here for demonstration purposes so you may know how IRSA works
data "tls_certificate" "eks_cluster" {
  url = local.eks_oidc_issuer_url
}

resource "aws_iam_openid_connect_provider" "oidc_provider" {
  url             = data.tls_certificate.eks_cluster.url
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks_cluster.certificates[0].sha1_fingerprint]
  tags            = local.tags
}

output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.oidc_provider.arn
}

output "oidc_provider_url_without_http_prefix" {
  value = aws_iam_openid_connect_provider.oidc_provider.url
}
