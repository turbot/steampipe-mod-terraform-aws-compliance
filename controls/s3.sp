locals {
  s3_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "s3"
  })
}

benchmark "s3" {
  title       = "S3"
  description = "This benchmark provides a set of controls that detect Terraform AWS S3 resources deviating from security best practices."

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

control "s3_bucket_cross_region_replication_enabled" {
  title       = "S3 bucket cross-region replication should enabled"
  description = "Amazon Simple Storage Service (Amazon S3) Cross-Region Replication (CRR) supports maintaining adequate capacity and availability."
  sql           = query.s3_bucket_cross_region_replication_enabled.sql

  tags = merge(local.s3_compliance_common_tags, {
    hipaa              = "true"
    nist_800_53_rev_4  = "true"
    nist_csf           = "true"
    pci                = "true"
    rbi_cyber_security = "true"
    soc_2              = "true"
  })
}

control "s3_bucket_default_encryption_enabled_kms" {
  title       = "S3 bucket default encryption should be enabled with KMS"
  description = "To help protect data at rest, ensure encryption is enabled for your Amazon Simple Storage Service (Amazon S3) buckets using KMS."
  sql           = query.s3_bucket_default_encryption_enabled_kms.sql

  tags = merge(local.s3_compliance_common_tags, {
    gdpr               = "true"
    hipaa              = "true"
    rbi_cyber_security = "true"
  })
}

control "s3_bucket_default_encryption_enabled" {
  title       = "S3 bucket default encryption should be enabled"
  description = "To help protect data at rest, ensure default encryption is enabled for your Amazon Simple Storage Service (Amazon S3) buckets."
  sql           = query.s3_bucket_default_encryption_enabled.sql

  tags = merge(local.s3_compliance_common_tags, {
    aws_foundational_security = "true"
    cis                       = "true"
    gdpr                      = "true"
    hipaa                     = "true"
    nist_800_53_rev_4         = "true"
    nist_csf                  = "true"
    pci                       = "true"
    rbi_cyber_security        = "true"
  })
}

control "s3_bucket_logging_enabled" {
   title       = "S3 bucket logging should be enabled"
  description = "Amazon Simple Storage Service (Amazon S3) server access logging provides a method to monitor the network for potential cybersecurity events."
  sql           = query.s3_bucket_logging_enabled.sql

  tags = merge(local.s3_compliance_common_tags, {
    hipaa              = "true"
    nist_800_53_rev_4  = "true"
    nist_csf           = "true"
    rbi_cyber_security = "true"
    soc_2              = "true"
  })
}

control "s3_bucket_mfa_delete_enabled" {
  title         = "Ensure MFA Delete is enabled on S3 buckets"
  description   = "Once MFA delete is enabled on your sensitive and classified S3 bucket it requires the user to have two forms of authentication."
  sql           = query.s3_bucket_mfa_delete_enabled.sql

  tags = merge(local.s3_compliance_common_tags, {
    cis = "true"
  })
}

control "s3_bucket_object_lock_enabled" {
  title       = "S3 bucket object lock should be enabled"
  description = "Ensure that your Amazon Simple Storage Service (Amazon S3) bucket has lock enabled, by default."
  sql           = query.s3_bucket_object_lock_enabled.sql

  tags = merge(local.s3_compliance_common_tags, {
    hipaa    = "true"
    nist_csf = "true"
    soc_2    = "true"
  })
}

control "s3_bucket_public_access_blocked" {
  title         = "S3 Block Public Access setting should be enabled at the bucket level"
  description   = "This control checks whether S3 buckets have bucket-level public access blocks applied."
  sql           = query.s3_bucket_public_access_blocked.sql

  tags = merge(local.s3_compliance_common_tags, {
    aws_foundational_security = "true"
  })
}

control "s3_bucket_versioning_enabled" {
  title       = "S3 bucket versioning should be enabled"
  description = "Amazon Simple Storage Service (Amazon S3) bucket versioning helps keep multiple variants of an object in the same Amazon S3 bucket."
  sql           = query.s3_bucket_versioning_enabled.sql

  tags = merge(local.s3_compliance_common_tags, {
    hipaa                       = "true"
    nist_csf                    = "true"
    rbi_cyber_security          = "true"
    soc_2                       = "true"
  })
}

control "s3_public_access_block_account" {
  title       = "S3 public access should be blocked at account level"
  description = "Manage access to resources in the AWS Cloud by ensuring that Amazon Simple Storage Service (Amazon S3) buckets cannot be publicly accessed."
  sql           = query.s3_public_access_block_account.sql

  tags = merge(local.s3_compliance_common_tags, {
    aws_foundational_security = "true"
    hipaa                     = "true"
    nist_800_53_rev_4         = "true"
    nist_csf                  = "true"
  })
}