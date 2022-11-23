module "eks_blueprints_kubernetes_addons" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons?ref=v4.17.0"

  eks_cluster_id       = data.terraform_remote_state.layer_05_eks_cluster.outputs.eks_cluster_id
  eks_cluster_endpoint = data.terraform_remote_state.layer_05_eks_cluster.outputs.eks_cluster_endpoint
  eks_oidc_provider    = data.terraform_remote_state.layer_05_eks_cluster.outputs.eks_oidc_issuer_url
  eks_cluster_version  = data.terraform_remote_state.layer_05_eks_cluster.outputs.eks_cluster_version

  # EKS Addons
  enable_amazon_eks_vpc_cni    = true
  enable_amazon_eks_coredns    = true
  enable_amazon_eks_kube_proxy = true

  tags = local.tags
}
