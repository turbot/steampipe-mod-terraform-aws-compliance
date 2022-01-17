locals {
  secretsmanager_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "secretsmanager"
  })
}

benchmark "secretsmanager" {
  title    = "Secrets Manager"
  children = [
    control.secretsmanager_secret_automatic_rotation_enabled,
    control.secretsmanager_secret_automatic_rotation_lambda_enabled,
  ]
  tags          = local.secretsmanager_compliance_common_tags
}

control "secretsmanager_secret_automatic_rotation_enabled" {
  title       = "Secrets Manager secrets should have automatic rotation enabled"
  description = "This rule ensures AWS Secrets Manager secrets have rotation enabled. Rotating secrets on a regular schedule can shorten the period a secret is active, and potentially reduce the business impact if the secret is compromised."
  sql           = query.secretsmanager_secret_automatic_rotation_enabled.sql

  tags = local.secretsmanager_compliance_common_tags
}

control "secretsmanager_secret_automatic_rotation_lambda_enabled" {
  title         = "Secrets Manager secrets should be rotated within a specified number of days"
  description   = "This control checks whether your secrets have been rotated at least once within 90 days. Rotating secrets can help you to reduce the risk of an unauthorized use of your secrets in your AWS account. Examples include database credentials, passwords, third-party API keys, and even arbitrary text. If you do not change your secrets for a long period of time, the secrets are more likely to be compromised."
  sql           = query.secretsmanager_secret_automatic_rotation_lambda_enabled.sql

  tags = local.secretsmanager_compliance_common_tags
}