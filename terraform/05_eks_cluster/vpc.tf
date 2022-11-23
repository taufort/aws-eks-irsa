data "aws_availability_zones" "available" {
}

module "eks_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name                   = "eks-vpc"
  cidr                   = "10.1.0.0/16"
  azs                    = data.aws_availability_zones.available.names
  enable_dns_hostnames   = true
  enable_nat_gateway     = true
  create_igw             = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
  public_subnets         = ["10.1.0.0/21", "10.1.8.0/21", "10.1.16.0/21"]
  private_subnets        = ["10.1.24.0/21", "10.1.32.0/21", "10.1.40.0/21"]

  enable_ipv6                     = true
  assign_ipv6_address_on_creation = true
  public_subnet_ipv6_prefixes     = [0, 1, 2]
  private_subnet_ipv6_prefixes    = [3, 4, 5]

  enable_flow_log                                 = true
  create_flow_log_cloudwatch_log_group            = true
  create_flow_log_cloudwatch_iam_role             = true
  flow_log_traffic_type                           = "REJECT"
  flow_log_cloudwatch_log_group_retention_in_days = 7

  tags = {
    author  = "taufort"
    project = var.project
  }
}
