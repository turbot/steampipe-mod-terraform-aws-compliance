locals {
  elasticache_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "elasticache"
  })
}

benchmark "elasticache" {
  title       = "ElastiCache"
  description = "This benchmark provides a set of controls that detect Terraform AWS ElastiCache resources deviating from security best practices."

  children = [
    control.elasticache_redis_cluster_automatic_backup_retention_15_days,
    control.elasticache_replication_group_encryption_in_transit_enabled
  ]

  tags = local.elasticache_compliance_common_tags
}

control "elasticache_redis_cluster_automatic_backup_retention_15_days" {
  title         = "ElastiCache Redis cluster automatic backup should be enabled with retention period of 15 days or greater"
  description   = "When automatic backups are enabled, Amazon ElastiCache creates a backup of the cluster on a daily basis. The backup can be retained for a number of days as specified by your organization. Automatic backups can help guard against data loss."
  sql           = query.elasticache_redis_cluster_automatic_backup_retention_15_days.sql

  tags = merge(local.elasticache_compliance_common_tags, {
    hipaa              = "true"
    nist_800_53_rev_4  = "true"
    nist_csf           = "true"
    rbi_cyber_security = "true"
    soc_2              = "true"
  })
}

control "elasticache_replication_group_encryption_in_transit_enabled" {
  title         = "ElastiCache replication group should be encrypted at transit"
  description   = "Ensure all data stored in the Elasticache Replication Group is securely encrypted at transit"
  sql           = query.elasticache_replication_group_encryption_in_transit_enabled.sql

  tags = local.elasticache_compliance_common_tags
}
