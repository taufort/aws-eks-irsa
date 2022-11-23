provider "aws" {
  region  = var.region
  profile = var.aws_profile
}

data "aws_eks_cluster_auth" "eks_token" {
  name = data.terraform_remote_state.layer_05_eks_cluster.outputs.eks_cluster_id
}

provider "kubernetes" {
  host                   = data.terraform_remote_state.layer_05_eks_cluster.outputs.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.layer_05_eks_cluster.outputs.eks_cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.eks_token.token
}

provider "helm" {
  kubernetes {
    host                   = data.terraform_remote_state.layer_05_eks_cluster.outputs.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(data.terraform_remote_state.layer_05_eks_cluster.outputs.eks_cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.eks_token.token
  }
}
