# aws-eks-irsa

[![GitHub Super-Linter](https://github.com/taufort/aws-eks-irsa/actions/workflows/linter.yml/badge.svg)](https://github.com/marketplace/actions/super-linter)

This project is a configuration example on how to setup IRSA on AWS EKS.

## Prerequisites

You need several tools to be able to interact with the infrastructure of this project:
- Terraform
- Terragrunt
- aws CLI v2
- kubectl
- helm v3

You can install those tools on your computer thanks to [tfswitch](https://github.com/warrensbox/terraform-switcher) and
to [tgswitch](https://github.com/warrensbox/tgswitch).

## How to initialize the infrastructure on an AWS account?

You first need to update the content of the local Terragrunt variable called `aws_profile` in file named
[terragrunt-global-config.hcl](terraform/terragrunt-global-config.hcl) to point to your AWS profile and not mine ;).

Once this is done, you can apply infrastructure with Terragrunt as such:
```bash
cd terraform
terragrunt run-all init
terragrunt run-all apply
```
The first Terragrunt command will run `terraform init` in every Terraform layer in the `terraform` folder. The second
Terragrunt command will run `terraform apply` in each layer.

> On the first apply, Terragrunt will ask you if you want to create the Terraform states S3 bucket if it does not exist
on your AWS account. It will also create a DynamoDB table for state locking.

## How is the AWS IAM OIDC provider created?

By default, the IAM OIDC provider is created by the
[AWS EKS blueprints for Terraform](https://github.com/aws-ia/terraform-aws-eks-blueprints/)
with the input `enable_irsa` which is set to `true` by default.

To show you how it works, I decided to set that input to `false` and create the OIDC provider with the AWS
provider resources myself (you can find those resources in the file named [irsa.tf](terraform/05_eks_cluster/irsa.tf)).

## How to access the EKS cluster?

`~/.kube/config` file gets updated with the EKS cluster details and certificate thanks to the below command:

```bash
aws eks --region eu-west-3 update-kubeconfig --name aws-eks-irsa --profile <YOUR_AWS_PROFILE>
```

Then, you can interact with the Kubernetes cluster with `kubectl` commands:
```bash
kubectl get pods -n kube-system
```

## How to deploy aws-cli Helm chart?

You can install the `aws-cli` Helm chart as such (after replacing `<YOUR_AWS_ACCOUNT_ID>` with your account ID):
```bash
helm upgrade --install --create-namespace --namespace aws-eks-irsa --set awsAccountId=<YOUR_AWS_ACCOUNT_ID> aws-cli helm/aws-cli
```

Then, you can check your resources were created into the EKS cluster:
```bash
kubectl get all -n aws-eks-irsa
```

When the `aws-cli` pod is running, connect to it and execute an AWS CLI command as such:
```bash
# Exec into the pod
kubectl exec -n aws-eks-irsa -it $(kubectl get pods -n aws-eks-irsa -o=name) -- bash
# Once inside the aws-cli pod, try to describe EC2 instances ;)
aws ec2 describe-instances --filters Name=tag:aws:eks:cluster-name,Values=aws-eks-irsa
```
