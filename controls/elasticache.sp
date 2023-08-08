locals {
  elasticache_compliance_common_tags = merge(local.terraform_aws_compliance_common_tags, {
    service = "AWS/ElastiCache"
  })
}

benchmark "elasticache" {
  title       = "ElastiCache"
  description = "This benchmark provides a set of controls that detect Terraform AWS ElastiCache resources deviating from security best practices."

  children = [
    control.elasticache_redis_cluster_automatic_backup_retention_15_days,
    control.elasticache_replication_group_encryption_in_transit_enabled_auth_token,
    control.elasticache_replication_group_encryption_at_rest_enabled,
    control.elasticache_replication_group_encrypted_with_kms_cmk,
    control.elasticache_redis_cluster_auto_minor_version_upgrade,
    control.elasticache_cluster_has_subnet_group,
    control.elasticache_replication_group_encryption_in_transit_enabled
  ]

  tags = merge(local.elasticache_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "elasticache_redis_cluster_automatic_backup_retention_15_days" {
  title       = "ElastiCache Redis cluster automatic backup should be enabled with retention period of 15 days or greater"
  description = "When automatic backups are enabled, Amazon ElastiCache creates a backup of the cluster on a daily basis. The backup can be retained for a number of days as specified by your organization. Automatic backups can help guard against data loss."
  query       = query.elasticache_redis_cluster_automatic_backup_retention_15_days

  tags = merge(local.elasticache_compliance_common_tags, {
    hipaa              = "true"
    nist_800_53_rev_4  = "true"
    nist_csf           = "true"
    rbi_cyber_security = "true"
    soc_2              = "true"
  })
}

control "elasticache_replication_group_encryption_in_transit_enabled" {
  title       = "ElastiCache replication group should be encrypted at transit"
  description = "Ensure all data stored in the Elasticache Replication Group is securely encrypted at transit"
  query       = query.elasticache_replication_group_encryption_in_transit_enabled

  tags = local.elasticache_compliance_common_tags
}

control "elasticache_replication_group_encryption_in_transit_enabled_auth_token" {
  title       = "ElastiCache replication group should be encrypted at transit"
  description = "This control checks whether all data stored in the Elasticache Replication Group is securely encrypted at transit."
  query       = query.elasticache_replication_group_encryption_in_transit_enabled_auth_token

  tags = local.elasticache_compliance_common_tags
}

control "elasticache_replication_group_encryption_at_rest_enabled" {
  title       = "ElastiCache replication group should be encrypted at rest"
  description = "This control checks whether all data stored in the Elasticache Replication Group is securely encrypted at rest."
  query       = query.elasticache_replication_group_encryption_at_rest_enabled

  tags = local.elasticache_compliance_common_tags
}

control "elasticache_replication_group_encrypted_with_kms_cmk" {
  title       = "ElastiCache replication group should be encrypted with KMS CMK"
  description = "This control checks whether all data stored in the Elasticache Replication Group is securely encrypted with KMS CMK."
  query       = query.elasticache_replication_group_encrypted_with_kms_cmk

  tags = local.elasticache_compliance_common_tags
}

control "elasticache_redis_cluster_auto_minor_version_upgrade" {
  title       = "ElastiCache Redis cluster should have auto minor version upgrade enabled"
  description = "This control checks whether the ElastiCache Redis cluster has auto minor version upgrade enabled."
  query       = query.elasticache_redis_cluster_auto_minor_version_upgrade

  tags = local.elasticache_compliance_common_tags
}

control "elasticache_cluster_has_subnet_group" {
  title       = "ElastiCache cluster should have subnet group"
  description = "This control checks whether the ElastiCache cluster has subnet group."
  query       = query.elasticache_cluster_has_subnet_group

  tags = local.elasticache_compliance_common_tags
}