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
