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
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
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
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
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
        when (arguments -> 'encryption_config' -> 'resources') @> '["secrets"]' then ' encrypted with EKS secrets'
        else ' not encrypted with EKS secrets'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_eks_cluster';
  EOQ
}

query "eks_cluster_run_on_supported_kubernetes_version" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'version') is null then 'skip'
        when (arguments ->> 'version') like any (array ['1.22', '1.23', '1.24', '1.25', '1.26']) then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'version') is null then ' kubernetes version not set'
        when (arguments ->> 'version') like any (array ['1.22', '1.23', '1.24', '1.25', '1.26']) then ' run on supported kubernetes version'
        else ' do not run on supported kubernetes version'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_eks_cluster';
  EOQ
}

query "eks_cluster_control_plane_logging_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'enabled_cluster_log_types') is null then 'alarm'
        when (arguments ->> 'enabled_cluster_log_types') like '%["api", "authenticator", "audit", "scheduler", "controllerManager"]%' then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments -> 'enabled_cluster_log_types') is null then ' control plane logging not set'
        when (arguments ->> 'enabled_cluster_log_types') like '%["api", "authenticator", "audit", "scheduler", "controllerManager"]%' then ' control plane logging enabled'
        else ' control plane logging disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_eks_cluster';
  EOQ
}