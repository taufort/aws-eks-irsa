module "cloudwatch_kms" {
  source  = "terraform-aws-modules/kms/aws"
  version = "~> 1.2"

  description = "CloudWatch logs usage"
  key_usage   = "ENCRYPT_DECRYPT"

  # Policy
  key_administrators = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
  key_statements = [
    {
      sid = "CloudWatchLogs"
      actions = [
        "kms:Encrypt*",
        "kms:Decrypt*",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:Describe*"
      ]
      resources = ["*"]

      principals = [
        {
          type        = "Service"
          identifiers = ["logs.${data.aws_region.current.name}.amazonaws.com"]
        }
      ]

      conditions = [
        {
          test     = "ArnLike"
          variable = "kms:EncryptionContext:aws:logs:arn"
          values = [
            "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:*",
          ]
        }
      ]
    }
  ]

  # Aliases
  aliases = ["${var.project}/cloudwatch"]

  tags = local.tags
}
