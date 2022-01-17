locals {
  kms_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "kms"
  })
}

benchmark "kms" {
  title    = "KMS"
  children = [
    control.kms_cmk_rotation_enabled
  ]
  tags          = local.kms_compliance_common_tags
}

control "kms_cmk_rotation_enabled" {
  title       = "KMS CMK rotation should be enabled"
  description = "Enable key rotation to ensure that keys are rotated once they have reached the end of their crypto period."
  sql           = query.kms_cmk_rotation_enabled.sql

  tags = local.kms_compliance_common_tags
}