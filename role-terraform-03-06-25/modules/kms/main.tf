resource "aws_kms_key" "kms" {
  description              = "${var.customer_name}-${var.Environment}-cmk"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  key_usage                = "ENCRYPT_DECRYPT"
  enable_key_rotation      = "false"
  multi_region             = "false"
  tags = var.kms_tags
}

resource "aws_kms_alias" "key_alias" {
  name          = "alias/${var.customer_name}-${var.Environment}-alias"
  target_key_id = aws_kms_key.kms.key_id
}

resource "aws_kms_key_policy" "kms_policy" {
  key_id = aws_kms_key.kms.id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "key-default-1",
  "Statement": [
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": { "AWS": "arn:aws:iam::${var.account_id}:root" },
      "Action": "kms:*",
      "Resource": "*"
    },
    {
      "Sid": "Allow service-linked role use of the customer managed key",
      "Effect": "Allow",
      "Principal": { "AWS": "arn:aws:iam::${var.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling" },
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ],
      "Resource": "*"
    },
    {
      "Sid": "Allow attachment of persistent resources",
      "Effect": "Allow",
      "Principal": { "AWS": "arn:aws:iam::${var.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling" },
      "Action": "kms:CreateGrant",
      "Resource": "*",
      "Condition": { "Bool": { "kms:GrantIsForAWSResource": "true" } }
    }
  ]
}
POLICY
}
