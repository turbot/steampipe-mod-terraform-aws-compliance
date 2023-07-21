locals {
  s3_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/S3"
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
    control.s3_public_access_block_account,
    control.s3_bucket_block_public_policy_enabled,
    control.s3_bucket_object_encrypted_with_kms_cmk,
    control.s3_bucket_object_copy_encrypted_with_kms_cmk,
    control.s3_bucket_ignore_public_acls_enabled,
    control.s3_bucket_abort_incomplete_multipart_upload_enabled
  ]

  tags = merge(local.s3_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "s3_bucket_cross_region_replication_enabled" {
  title       = "S3 bucket cross-region replication should enabled"
  description = "Amazon Simple Storage Service (Amazon S3) Cross-Region Replication (CRR) supports maintaining adequate capacity and availability."
  query       = query.s3_bucket_cross_region_replication_enabled

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
  query       = query.s3_bucket_default_encryption_enabled_kms

  tags = merge(local.s3_compliance_common_tags, {
    gdpr               = "true"
    hipaa              = "true"
    rbi_cyber_security = "true"
  })
}

control "s3_bucket_default_encryption_enabled" {
  title       = "S3 bucket default encryption should be enabled"
  description = "To help protect data at rest, ensure default encryption is enabled for your Amazon Simple Storage Service (Amazon S3) buckets."
  query       = query.s3_bucket_default_encryption_enabled

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
  query       = query.s3_bucket_logging_enabled

  tags = merge(local.s3_compliance_common_tags, {
    hipaa              = "true"
    nist_800_53_rev_4  = "true"
    nist_csf           = "true"
    rbi_cyber_security = "true"
    soc_2              = "true"
  })
}

control "s3_bucket_mfa_delete_enabled" {
  title       = "Ensure MFA Delete is enabled on S3 buckets"
  description = "Once MFA delete is enabled on your sensitive and classified S3 bucket it requires the user to have two forms of authentication."
  query       = query.s3_bucket_mfa_delete_enabled

  tags = merge(local.s3_compliance_common_tags, {
    cis = "true"
  })
}

control "s3_bucket_object_lock_enabled" {
  title       = "S3 bucket object lock should be enabled"
  description = "Ensure that your Amazon Simple Storage Service (Amazon S3) bucket has lock enabled, by default."
  query       = query.s3_bucket_object_lock_enabled

  tags = merge(local.s3_compliance_common_tags, {
    hipaa    = "true"
    nist_csf = "true"
    soc_2    = "true"
  })
}

control "s3_bucket_public_access_blocked" {
  title       = "S3 Block Public Access setting should be enabled at the bucket level"
  description = "This control checks whether S3 buckets have bucket-level public access blocks applied."
  query       = query.s3_bucket_public_access_blocked

  tags = merge(local.s3_compliance_common_tags, {
    aws_foundational_security = "true"
  })
}

control "s3_bucket_versioning_enabled" {
  title       = "S3 bucket versioning should be enabled"
  description = "Amazon Simple Storage Service (Amazon S3) bucket versioning helps keep multiple variants of an object in the same Amazon S3 bucket."
  query       = query.s3_bucket_versioning_enabled

  tags = merge(local.s3_compliance_common_tags, {
    hipaa              = "true"
    nist_csf           = "true"
    rbi_cyber_security = "true"
    soc_2              = "true"
  })
}

control "s3_public_access_block_account" {
  title       = "S3 public access should be blocked at account level"
  description = "Manage access to resources in the AWS Cloud by ensuring that Amazon Simple Storage Service (Amazon S3) buckets cannot be publicly accessed."
  query       = query.s3_public_access_block_account

  tags = merge(local.s3_compliance_common_tags, {
    aws_foundational_security = "true"
    hipaa                     = "true"
    nist_800_53_rev_4         = "true"
    nist_csf                  = "true"
  })
}

control "s3_bucket_block_public_policy_enabled" {
  title       = "S3 bucket should have block public policy enabled"
  description = "Manage access to resources in the AWS Cloud by ensuring that Amazon Simple Storage Service (Amazon S3) buckets cannot be publicly accessed."
  query       = query.s3_bucket_block_public_policy_enabled

  tags =local.s3_compliance_common_tags
}

control "s3_bucket_object_encrypted_with_kms_cmk" {
  title       = "S3 bucket object should be encrypted with KMS customer managed Key (CMK)"
  description = "Make sure that the object in the S3 bucket is encrypted using a customer managed Key (CMK) from KMS."
  query       = query.s3_bucket_object_encrypted_with_kms_cmk

  tags =local.s3_compliance_common_tags
}

control "s3_bucket_ignore_public_acls_enabled" {
  title       = "S3 bucket should have ignore public ACLs enabled"
  description = "Manage access to resources in the AWS Cloud by ensuring that Amazon Simple Storage Service (Amazon S3) buckets cannot be publicly accessed."
  query       = query.s3_bucket_ignore_public_acls_enabled

  tags =local.s3_compliance_common_tags
}

control "s3_bucket_object_copy_encrypted_with_kms_cmk" {
  title       = "S3 bucket object copy should be encrypted with KMS customer managed Key (CMK)"
  description = "Make sure that the object in the S3 bucket is encrypted using a customer managed Key (CMK) from KMS."
  query       = query.s3_bucket_object_copy_encrypted_with_kms_cmk

  tags =local.s3_compliance_common_tags
}

control "s3_bucket_abort_incomplete_multipart_upload_enabled" {
  title       = "S3 bucket lifecycle configuration should have abort incomplete multipar uploads enabled"
  description = "Ensure that the S3 lifecycle configuration includes a rule to set a specific period for automatically aborting failed uploads."
  query       = query.s3_bucket_abort_incomplete_multipart_upload_enabled

  tags =local.s3_compliance_common_tags
}
