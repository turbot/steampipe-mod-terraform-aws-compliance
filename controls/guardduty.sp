locals {
  guardduty_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "emr"
  })
}

benchmark "guardduty" {
  title       = "GuardDuty"
  description = "This benchmark provides a set of controls that detect Terraform AWS GuardDuty resources deviating from security best practices."

  children = [
    control.guardduty_enabled
  ]
  
  tags = local.guardduty_compliance_common_tags
}

control "guardduty_enabled" {
  title       = "GuardDuty should be enabled"
  description = "Amazon GuardDuty can help to monitor and detect potential cybersecurity events by using threat intelligence feeds."
  sql           = query.guardduty_enabled.sql

  tags = merge(local.guardduty_compliance_common_tags, {
    aws_foundational_security = "true"
    pci                       = "true"
    hipaa                     = "true"
    nist_800_53_rev_4         = "true"
    nist_csf                  = "true"
    soc_2                     = "true"
  })
}