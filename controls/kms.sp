locals {
  kms_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/KMS"
  })
}

benchmark "kms" {
  title       = "KMS"
  description = "This benchmark provides a set of controls that detect Terraform AWS KMS resources deviating from security best practices."

  children = [
    control.kms_cmk_rotation_enabled
  ]

  tags = merge(local.kms_compliance_common_tags, {
    type    = "Benchmark"
  })
}

control "kms_cmk_rotation_enabled" {
  title       = "KMS CMK rotation should be enabled"
  description = "Enable key rotation to ensure that keys are rotated once they have reached the end of their crypto period."
  sql           = query.kms_cmk_rotation_enabled.sql

  tags = merge(local.kms_compliance_common_tags, {
    cis                = "true"
    hippa              = "true"
    gdpr               = "true"
    nist_800_53_rev_4  = "true"
    pci                = "true"
    rbi_cyber_security = "true"
  })
}