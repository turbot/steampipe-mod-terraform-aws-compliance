locals {
  cloudtrail_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "cloudtrail"
  })
}

benchmark "cloudtrail" {
  title         = "CloudTrail"
  children = [
    control.cloudtrail_enabled_all_regions,
    control.cloudtrail_trail_logs_encrypted_with_kms_cmk,
    control.cloudtrail_trail_validation_enabled,
  ]
  tags          = local.cloudtrail_compliance_common_tags
}
