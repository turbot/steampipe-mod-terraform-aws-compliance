query "neptune_cluster_encryption_at_rest_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'storage_encrypted')::boolean then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments ->> 'storage_encrypted')::boolean then ' encrypted at rest'
        else ' not encrypted at rest'
      end || '.' as reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_neptune_cluster';
  EOQ
}

query "neptune_cluster_logging_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'enable_cloudwatch_logs_exports') is null then 'alarm'
        else 'ok'
      end as status,
      name || case
        when (arguments -> 'enable_cloudwatch_logs_exports') is null then ' logging not enabled'
        else ' logging enabled'
      end || '.' as reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_neptune_cluster';
  EOQ
}
