query "eks_cluster_endpoint_restrict_public_access" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'endpoint_public_access')::boolean then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'endpoint_public_access')::boolean then ' endpoint publicly accessible'
        else ' endpoint not publicly accessible'
      end || '.' reason,
      path || ':' || start_line
    from
      terraform_resource
    where
      type = 'aws_eks_cluster';
  EOQ
}

query "eks_cluster_log_types_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'enabled_cluster_log_types') is null then 'alarm'
        else 'ok'
      end as status,
      name || case
        when (arguments -> 'enabled_cluster_log_types') is null then ' logging disabled'
        else ' logging enabled'
      end || '.' as reason,
      path || ':' || start_line
    from
      terraform_resource
    where
      type = 'aws_eks_cluster';
  EOQ
}

query "eks_cluster_secrets_encrypted" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'encryption_config') is null then 'alarm'
        when (arguments -> 'encryption_config' -> 'resources') @> '["secrets"]' then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'encryption_config') is null then ' encryption disabled'
        when (arguments -> 'encryption_config' -> 'resources') @> '["secrets"]' then 'encrypted with EKS secrets'
        else ' not encrypted with EKS secrets'
      end || '.' reason,
      path || ':' || start_line
    from
      terraform_resource
    where
      type = 'aws_eks_cluster';
  EOQ
}
