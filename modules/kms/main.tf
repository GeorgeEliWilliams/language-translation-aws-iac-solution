resource "aws_kms_key" "this" {
  description              = var.kms_vars["description"]
  deletion_window_in_days  = var.kms_vars["deletion_window_in_days"]
  enable_key_rotation      = var.kms_vars["enable_key_rotation"]
  key_usage                = var.kms_vars["key_usage"]
  customer_master_key_spec = var.kms_vars["customer_master_key_spec"]

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "key-default-1"
    Statement = concat(
      [
        {
          Sid    = "EnableIAMUserPermissions"
          Effect = "Allow"
          Principal = {
            AWS = "arn:aws:iam::${data.aws_caller_identity.this.account_id}:root"
          }
          Action   = "kms:*"
          Resource = "*"
        },
        {
          Sid    = "AllowLambdaAndS3Access"
          Effect = "Allow"
          Principal = {
            Service = ["s3.amazonaws.com", "logs.amazonaws.com"]
          }
          Action = [
            "kms:Encrypt",
            "kms:Decrypt",
            "kms:GenerateDataKey*",
            "kms:DescribeKey"
          ]
          Resource = "*"
        },
        {
          Sid    = "AllowProject"
          Effect = "Allow"
          Principal = {
            AWS = "arn:aws:iam::${data.aws_caller_identity.this.account_id}:root"
          }
          Action = [
            "kms:Encrypt",
            "kms:Decrypt",
            "kms:GenerateDataKey*",
            "kms:DescribeKey"
          ]
          Resource = "*"
          Condition = {
            "StringLike" : {
              "aws:PrincipalArn": "arn:aws:iam::${data.aws_caller_identity.this.account_id}:role/${var.project}-*"
            }
          }
        }
      ],
      length(var.key_owners) > 0 ? [
        {
          Sid    = "AllowFullAccessForKeyOwners"
          Effect = "Allow"
          Principal = {
            AWS = var.key_owners
          }
          Action   = "kms:*"
          Resource = "*"
        }
      ] : [],
      length(var.key_admins) > 0 ? [
        {
          Sid    = "AllowAdministrationForKeyAdmins"
          Effect = "Allow"
          Principal = {
            AWS = var.key_admins
          }
          Action = [
            "kms:Create*",
            "kms:Describe*",
            "kms:Enable*",
            "kms:List*",
            "kms:Put*",
            "kms:Update*",
            "kms:Revoke*",
            "kms:Disable*",
            "kms:Get*",
            "kms:Delete*",
            "kms:ScheduleKeyDeletion",
            "kms:CancelKeyDeletion"
          ]
          Resource = "*"
        }
      ] : [],
      length(var.key_users) > 0 ? [
        {
          Sid    = "AllowKeyUsageForKeyUsers"
          Effect = "Allow"
          Principal = {
            AWS = var.key_users
          }
          Action = [
            "kms:Encrypt",
            "kms:Decrypt",
            "kms:ReEncrypt*",
            "kms:GenerateDataKey*",
            "kms:DescribeKey"
          ]
          Resource = "*"
        }
      ] : []
    )
  })

  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-KMS-Key"
    }
  )
}

resource "aws_kms_alias" "this" {
  for_each      = { for alias in var.aliases : alias => alias }
  name          = each.value
  target_key_id = aws_kms_key.this.id
}
