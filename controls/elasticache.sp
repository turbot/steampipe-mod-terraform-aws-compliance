locals {
  elasticache_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "elasticache_"
  })
}

benchmark "elasticache" {
  title         = "ElastiCache"
  children = [
    control.elasticache_redis_cluster_automatic_backup_retention_15_days,
    control.elasticache_replication_group_encryption_in_transit_enabled
  ]
  tags          = local.elasticache_compliance_common_tags
}
