locals {
  guardduty_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "emr"
  })
}

benchmark "guardduty" {
  title    = "GuardDuty"
  children = [
    control.guardduty_enabled
  ]
  tags          = local.guardduty_compliance_common_tags
}

control "guardduty_enabled" {
  title       = "GuardDuty should be enabled"
  description = "Amazon GuardDuty can help to monitor and detect potential cybersecurity events by using threat intelligence feeds."
  sql           = query.guardduty_enabled.sql

  tags = local.guardduty_compliance_common_tags
}