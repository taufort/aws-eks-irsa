# Generated by Terragrunt. Sig: nIlQXj57tbuaRZEa
terraform {
  backend "s3" {
    bucket         = "taufort-aws-eks-irsa-tf-states"
    dynamodb_table = "taufort-aws-eks-irsa-tf-states"
    encrypt        = true
    key            = "10_eks_resources/terraform.tfstate"
    profile        = "ippon-sandbox"
    region         = "eu-west-3"
  }
}
