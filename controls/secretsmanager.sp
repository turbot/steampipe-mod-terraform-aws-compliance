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
