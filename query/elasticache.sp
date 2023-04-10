query "elasticache_redis_cluster_automatic_backup_retention_15_days" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'snapshot_retention_limit')::int < 15 then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'snapshot_retention_limit')::int is null then ' automatic backups disabled'
        when (arguments -> 'snapshot_retention_limit')::int < 15 then ' automatic backup retention period is less than 15 days'
        else ' automatic backup retention period is more than 15 days'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_elasticache_replication_group';
  EOQ
}

query "elasticache_replication_group_encryption_in_transit_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'transit_encryption_enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'transit_encryption_enabled')::boolean then ' encrypted in transit'
        else ' not encrypted in transit'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_elasticache_replication_group';
  EOQ
}

