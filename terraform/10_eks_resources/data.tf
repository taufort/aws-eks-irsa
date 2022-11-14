data "terraform_remote_state" "layer_05_eks_cluster" {
  backend = "s3"
  config = {
    bucket  = "taufort-aws-eks-irsa-tf-states"
    key     = "05_eks_cluster/terraform.tfstate"
    region  = "eu-west-3"
    profile = var.aws_profile
  }
}
