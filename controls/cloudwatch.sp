locals {
  cloudwatch_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/CloudWatch"
  })
}

benchmark "cloudwatch" {
  title        = "CloudWatch"
  description  = "This benchmark provides a set of controls that detect Terraform AWS CloudWatch resources deviating from security best practices."

  children = [
    control.cloudwatch_alarm_action_enabled,
    control.cloudwatch_destination_policy_wildcards,
    control.cloudwatch_log_group_retention_period_365,
    control.log_group_encryption_at_rest_enabled
  ]

  tags = merge(local.cloudwatch_compliance_common_tags, {
    type    = "Benchmark"
  })
}

control "cloudwatch_alarm_action_enabled" {
  title         = "CloudWatch alarm action should be enabled"
  description   = "Amazon CloudWatch alarms alert when a metric breaches the threshold for a specified number of evaluation periods. The alarm performs one or more actions based on the value of the metric or expression relative to a threshold over a number of time periods."
  sql           = query.cloudwatch_alarm_action_enabled.sql

  tags = merge(local.cloudwatch_compliance_common_tags, {
    hipaa             = "true"
    nist_800_53_rev_4 = "true"
    nist_csf          = "true"
    soc_2             = "true"
  })
}

control "cloudwatch_destination_policy_wildcards" {
  title         = "Ensure CloudWatch Logs destination policy has no wildcards"
  description   = "Amazon CloudWatch Logs destination policy should avoid wildcard in 'principals' and 'actions'."
  sql           = query.cloudwatch_destination_policy_wildcards.sql

  tags = local.cloudwatch_compliance_common_tags
}

control "cloudwatch_log_group_retention_period_365" {
  title         = "Log group retention period should be at least 365 days"
  description   = "Ensure a minimum duration of event log data is retained for your log groups to help with troubleshooting and forensics investigations."
  sql           = query.cloudwatch_log_group_retention_period_365.sql

  tags = merge(local.cloudwatch_compliance_common_tags, {
    hipaa              = "true"
    nist_800_53_rev_4  = "true"
    rbi_cyber_security = "true"
    soc_2              = "true"
  })
}

control "log_group_encryption_at_rest_enabled" {
  title         = "Log group encryption at rest should be enabled"
  description   = "To help protect sensitive data at rest, ensure encryption is enabled for your Amazon CloudWatch Log Group."
  sql           = query.log_group_encryption_at_rest_enabled.sql

   tags = merge(local.cloudwatch_compliance_common_tags, {
    gdpr               = "true"
    hipaa              = "true"
    nist_800_53_rev_4  = "true"
    nist_csf           = "true"
    rbi_cyber_security = "true"
    soc_2              = "true"
  })
}