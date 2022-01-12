locals {
  conformance_pack_kms_common_tags = {
    service = "kms"
  }
}

control "kms_cmk_rotation_enabled" {
  title       = "KMS CMK rotation should be enabled"
  description = "Enable key rotation to ensure that keys are rotated once they have reached the end of their crypto period."
  sql           = query.kms_cmk_rotation_enabled.sql

  tags = local.conformance_pack_kms_common_tags
}