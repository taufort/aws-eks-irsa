variable "aws_profile" {
  description = "Default AWS profile used as AWS credentials (passed in from terragrunt-global-config.hcl)"
  type        = string
}

variable "region" {
  default     = "eu-west-3"
  description = "AWS region"
  type        = string
}

variable "project" {
  default     = "aws-eks-irsa"
  description = "Name of the git project"
  type        = string
}
