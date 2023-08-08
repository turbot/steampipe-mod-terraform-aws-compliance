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

query "elasticache_replication_group_encryption_in_transit_enabled_auth_token" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'transit_encryption_enabled')::boolean and (arguments ->> 'auth_token') is not null then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'transit_encryption_enabled')::boolean and (arguments ->> 'auth_token') is not null then ' encrypted in transit and auth token set'
        when (arguments ->> 'transit_encryption_enabled')::boolean and (arguments ->> 'auth_token') is null then ' encrypted in transit but auth token not set'
        when (arguments ->> 'auth_token') is not null then 'not encrypted in transit but auth token set'
        else ' not encrypted in transit and auth token not set'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_elasticache_replication_group';
  EOQ
}

query "elasticache_replication_group_encryption_at_rest_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'at_rest_encryption_enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'at_rest_encryption_enabled')::boolean then ' encrypted at rest'
        else ' not encrypted at rest'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_elasticache_replication_group';
  EOQ
}

query "elasticache_replication_group_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'kms_key_id') is not null then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'kms_key_id') is not null then ' encrypted with kms cmk'
        else ' not encrypted with kms cmk'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_elasticache_replication_group';
  EOQ
}

query "elasticache_redis_cluster_auto_minor_version_upgrade" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'auto_minor_version_upgrade')::boolean then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'auto_minor_version_upgrade')::boolean then ' auto minor version upgrade enabled'
        else ' auto minor version upgrade disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_elasticache_cluster';
  EOQ
}

query "elasticache_cluster_has_subnet_group" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'subnet_group_name') is not null then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'subnet_group_name') is not null then ' subnet group name set'
        else ' subnet group name not set'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_elasticache_cluster';
  EOQ  
}