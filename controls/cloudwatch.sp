locals {
  cloudwatch_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "cloudwatch"
  })
}

benchmark "cloudwatch" {
  title         = "CloudWatch"
  children = [
    control.cloudwatch_alarm_action_enabled,
    control.cloudwatch_log_group_retention_period_365,
    control.log_group_encryption_at_rest_enabled,
  ]
  tags          = local.cloudwatch_compliance_common_tags
}
