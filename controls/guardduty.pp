locals {
  guardduty_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/GuardDuty"
  })
}

benchmark "guardduty" {
  title       = "GuardDuty"
  description = "This benchmark provides a set of controls that detect Terraform AWS GuardDuty resources deviating from security best practices."

  children = [
    control.guardduty_enabled
  ]

  tags = merge(local.guardduty_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "guardduty_enabled" {
  title       = "GuardDuty should be enabled"
  description = "Amazon GuardDuty can help to monitor and detect potential cybersecurity events by using threat intelligence feeds."
  query       = query.guardduty_enabled

  tags = merge(local.guardduty_compliance_common_tags, {
    aws_foundational_security = "true"
    pci                       = "true"
    hipaa                     = "true"
    nist_800_53_rev_4         = "true"
    nist_csf                  = "true"
    soc_2                     = "true"
  })
}
