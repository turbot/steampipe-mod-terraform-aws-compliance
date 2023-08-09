query "dax_cluster_encryption_at_rest_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'server_side_encryption') is null then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'server_side_encryption') is null then ' encryption at rest disabled'
        else ' encryption at rest disabled enabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_dax_cluster';
  EOQ
}

query "dax_cluster_endpoint_encryption_tls_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'cluster_endpoint_encryption_type') = 'TLS' then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'cluster_endpoint_encryption_type') = 'TLS' then ' endpoint encryption tls enabled'
        else ' endpoint encryption tls disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_dax_cluster';
  EOQ
}