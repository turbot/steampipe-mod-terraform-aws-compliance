locals {
  neptune_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/Neptune"
  })
}

benchmark "neptune" {
  title       = "Neptune"
  description = "This benchmark provides a set of controls that detect Terraform AWS Neptune resources deviating from security best practices."

  children = [
    control.neptune_cluster_backup_retention_period_7,
    control.neptune_cluster_copy_tags_to_snapshot_enabled,
    control.neptune_cluster_encrypted_with_kms_cmk,
    control.neptune_cluster_encryption_at_rest_enabled,
    control.neptune_cluster_iam_authentication_enabled,
    control.neptune_cluster_instance_publicly_accessible,
    control.neptune_cluster_logging_enabled,
    control.neptune_snapshot_encrypted_with_kms_cmk,
    control.neptune_snapshot_storage_encryption_enabled,
  ]

  tags = merge(local.neptune_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "neptune_cluster_logging_enabled" {
  title       = "Neptune logging should be enabled"
  description = "Ensure Neptune logging is enabled. These access logs can be used to analyze traffic patterns and troubleshoot security and operational issues."
  query       = query.neptune_cluster_logging_enabled

  tags = local.neptune_compliance_common_tags
}

control "neptune_cluster_encryption_at_rest_enabled" {
  title       = "Neptune cluster encryption at rest should be enabled"
  description = "Ensure Neptune clusters being created are set to be encrypted at rest to protect sensitive data."
  query       = query.neptune_cluster_encryption_at_rest_enabled

  tags = local.neptune_compliance_common_tags
}

control "neptune_cluster_encrypted_with_kms_cmk" {
  title       = "Neptune cluster should be encrypted with KMS CMK"
  description = "This control checks whether Neptune clusters are encrypted with KMS CMK."
  query       = query.neptune_cluster_encrypted_with_kms_cmk

  tags = local.neptune_compliance_common_tags
}

control "neptune_cluster_instance_publicly_accessible" {
  title       = "Neptune cluster instance should not be publicly accessible"
  description = "This control checks whether Neptune cluster instances are not publicly accessible."
  query       = query.neptune_cluster_instance_publicly_accessible

  tags = local.neptune_compliance_common_tags
}

control "neptune_snapshot_storage_encryption_enabled" {
  title       = "Neptune snapshot storage encryption should be enabled"
  description = "This control checks whether Neptune snapshot storage encryption is enabled. These snapshots contain sensitive data and should be encrypted at rest."
  query       = query.neptune_snapshot_storage_encryption_enabled

  tags = local.neptune_compliance_common_tags
}

control "neptune_snapshot_encrypted_with_kms_cmk" {
  title       = "Neptune snapshot should be encrypted with KMS CMK"
  description = "This control checks whether Neptune snapshots are encrypted with KMS CMK."
  query       = query.neptune_snapshot_encrypted_with_kms_cmk

  tags = local.neptune_compliance_common_tags
}

control "neptune_cluster_backup_retention_period_7" {
  title       = "Neptune cluster backup retention period should be at least 7 days"
  description = "This control checks whether Neptune cluster backup retention is set to 7 or greater than 7."
  query       = query.neptune_cluster_backup_retention_period_7

  tags = local.neptune_compliance_common_tags
}

control "neptune_cluster_copy_tags_to_snapshot_enabled" {
  title       = "Neptune clusters should be configured to copy tags to snapshots"
  description = "This control checks whether Neptune clusters are configured to copy all tags to snapshots when the snapshots are created."
  query       = query.neptune_cluster_copy_tags_to_snapshot_enabled

  tags = local.neptune_compliance_common_tags
}

control "neptune_cluster_iam_authentication_enabled" {
  title       = "Neptune clusters should have IAM authentication enabled"
  description = "Checks if an Neptune cluster has AWS Identity and Access Management (IAM) authentication enabled."
  query       = query.neptune_cluster_iam_authentication_enabled

  tags = local.neptune_compliance_common_tags
}