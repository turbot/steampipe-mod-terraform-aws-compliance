locals {
  dms_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/DMS"
  })
}

benchmark "dms" {
  title       = "DMS"
  description = "This benchmark provides a set of controls that detect Terraform AWS DMS resources deviating from security best practices."

  children = [
    control.dms_replication_instance_automatic_minor_version_upgrade_enabled,
    control.dms_replication_instance_encrypted_with_kms_cmk,
    control.dms_replication_instance_not_publicly_accessible,
    control.dms_s3_endpoint_encrypted_with_kms_cmk,
    control.dms_s3_endpoint_encryption_in_transit_enabled
  ]

  tags = merge(local.dms_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "dms_replication_instance_not_publicly_accessible" {
  title       = "DMS replication instances should not be publicly accessible"
  description = "Manage access to the AWS Cloud by ensuring DMS replication instances cannot be publicly accessed."
  query       = query.dms_replication_instance_not_publicly_accessible

  tags = merge(local.dms_compliance_common_tags, {
    aws_foundational_security = "true"
    hipaa                     = "true"
    nist_800_53_rev_4         = "true"
    nist_csf                  = "true"
    pci                       = "true"
    rbi_cyber_security        = "true"
  })
}

control "dms_replication_instance_encrypted_with_kms_cmk" {
  title       = "DMS replication instances should be encrypted with KMS CMK"
  description = "This control checks whether DMS replication instances are encrypted with customer-managed key."
  query       = query.dms_replication_instance_encrypted_with_kms_cmk

  tags = local.dms_compliance_common_tags
}

control "dms_replication_instance_automatic_minor_version_upgrade_enabled" {
  title       = "DMS replication instances should have automatic minor version upgrade enabled"
  description = "This control checks whether DMS replication instances have automatic minor version upgrade enabled."
  query       = query.dms_replication_instance_automatic_minor_version_upgrade_enabled

  tags = local.dms_compliance_common_tags
}

control "dms_s3_endpoint_encrypted_with_kms_cmk" {
  title       = "DMS S3 endpoints should be encrypted with KMS CMK"
  description = "This control checks whether DMS S3 endpoints are encrypted with customer-managed key."
  query       = query.dms_s3_endpoint_encrypted_with_kms_cmk

  tags = local.dms_compliance_common_tags
}

control "dms_s3_endpoint_encryption_in_transit_enabled" {
  title       = "DMS S3 endpoints should be encrypted at transit"
  description = "This control checks whether DMS S3 endpoints are securely encrypted at transit."
  query       = query.dms_s3_endpoint_encryption_in_transit_enabled

  tags = local.dms_compliance_common_tags
}