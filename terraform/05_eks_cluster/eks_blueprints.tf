module "eks_blueprints" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints?ref=v4.17.0"

  # EKS CLUSTER
  cluster_name       = var.project
  cluster_version    = "1.24"
  vpc_id             = module.eks_vpc.vpc_id
  private_subnet_ids = module.eks_vpc.private_subnets

  # EKS MANAGED NODE GROUPS
  managed_node_groups = {
    mg_t3 = {
      node_group_name = "t3-managed-ondemand"
      instance_types  = ["t3.large"]
      subnet_ids      = module.eks_vpc.private_subnets
    }
  }

  # CLOUDWATCH
  create_cloudwatch_log_group            = true
  cloudwatch_log_group_retention_in_days = 7
  cloudwatch_log_group_kms_key_id        = module.cloudwatch_kms.key_arn

  cluster_ip_family = "ipv4"

  # VOLUNTARILY DISABLE IRSA IN BLUEPRINTS
  enable_irsa = false

  tags = local.tags
}

output "eks_cluster_id" {
  value = module.eks_blueprints.eks_cluster_id
}

output "eks_cluster_endpoint" {
  value = module.eks_blueprints.eks_cluster_endpoint
}

output "eks_cluster_certificate_authority_data" {
  value = module.eks_blueprints.eks_cluster_certificate_authority_data
}

output "eks_oidc_issuer_url" {
  value = module.eks_blueprints.eks_oidc_issuer_url
}

output "eks_cluster_version" {
  value = module.eks_blueprints.eks_cluster_version
}
