locals {
  s3_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "s3"
  })
}

benchmark "s3" {
  title    = "S3"
  children = [
    control.s3_bucket_cross_region_replication_enabled,
    control.s3_bucket_default_encryption_enabled_kms,
    control.s3_bucket_default_encryption_enabled,
    control.s3_bucket_logging_enabled,
    control.s3_bucket_mfa_delete_enabled,
    control.s3_bucket_object_lock_enabled,
    control.s3_bucket_public_access_blocked,
    control.s3_bucket_versioning_enabled,
    control.s3_public_access_block_account
  ]
  tags          = local.s3_compliance_common_tags
}
