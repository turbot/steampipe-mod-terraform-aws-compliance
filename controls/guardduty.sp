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
