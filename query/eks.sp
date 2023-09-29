query "eks_cluster_endpoint_restrict_public_access" {
  sql = <<-EOQ
    select
      address as resource,
      case
        -- In case both endpoint_public_access & public_access_cidrs are not configured in vpc_config then default setting is true and public_access_cidrs accessible to internet
        when (attributes_std -> 'vpc_config' ->> 'endpoint_public_access') is null and (attributes_std -> 'vpc_config' -> 'public_access_cidrs') is null then 'alarm'
        when (attributes_std -> 'vpc_config' ->> 'endpoint_public_access')::boolean and (attributes_std -> 'vpc_config' -> 'public_access_cidrs') is null then 'alarm'
        when (attributes_std -> 'vpc_config' ->> 'endpoint_public_access')::boolean and (attributes_std -> 'vpc_config' -> 'public_access_cidrs') @> '["0.0.0.0/0"]' then 'alarm'
        when (attributes_std -> 'vpc_config' ->> 'endpoint_public_access') is null and (attributes_std -> 'vpc_config' -> 'public_access_cidrs') @> '["0.0.0.0/0"]' then 'alarm'
        else 'ok'
      end status,
      address || case
        when (attributes_std -> 'vpc_config' ->> 'endpoint_public_access') is null and (attributes_std -> 'vpc_config' -> 'public_access_cidrs') is null then ' endpoint publicly accessible'
        when (attributes_std -> 'vpc_config' ->> 'endpoint_public_access')::boolean and (attributes_std -> 'vpc_config' -> 'public_access_cidrs') is null then ' endpoint publicly accessible'
        when (attributes_std -> 'vpc_config' ->> 'endpoint_public_access')::boolean and (attributes_std -> 'vpc_config' -> 'public_access_cidrs') @> '["0.0.0.0/0"]' then ' endpoint publicly accessible'
        when (attributes_std -> 'vpc_config' ->> 'endpoint_public_access') is null and (attributes_std -> 'vpc_config' -> 'public_access_cidrs') @> '["0.0.0.0/0"]' then ' endpoint publicly accessible'
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
      address as resource,
      case
        when (attributes_std -> 'enabled_cluster_log_types') is null then 'alarm'
        else 'ok'
      end as status,
      address || case
        when (attributes_std -> 'enabled_cluster_log_types') is null then ' logging disabled'
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
      address as resource,
      case
        when (attributes_std -> 'encryption_config') is null then 'alarm'
        when (attributes_std -> 'encryption_config' -> 'resources') @> '["secrets"]' then 'ok'
        else 'alarm'
      end status,
      address || case
        when (attributes_std -> 'encryption_config') is null then ' encryption disabled'
        when (attributes_std -> 'encryption_config' -> 'resources') @> '["secrets"]' then ' encrypted with EKS secrets'
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
      address as resource,
      case
        when (attributes_std ->> 'version') is null then 'skip'
        when (attributes_std ->> 'version') like any (array ['1.22', '1.23', '1.24', '1.25', '1.26']) then 'ok'
        else 'alarm'
      end status,
      address || case
        when (attributes_std ->> 'version') is null then ' Kubernetes version not set'
        when (attributes_std ->> 'version') like any (array ['1.22', '1.23', '1.24', '1.25', '1.26']) then ' run on supported Kubernetes version'
        else ' do not run on supported Kubernetes version'
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
      address as resource,
      case
        when (attributes_std -> 'enabled_cluster_log_types') is null then 'alarm'
        when (attributes_std ->> 'enabled_cluster_log_types') like '%["api", "authenticator", "audit", "scheduler", "controllerManager"]%' then 'ok'
        else 'alarm'
      end as status,
      address || case
        when (attributes_std -> 'enabled_cluster_log_types') is null then ' control plane logging not set'
        when (attributes_std ->> 'enabled_cluster_log_types') like '%["api", "authenticator", "audit", "scheduler", "controllerManager"]%' then ' control plane logging enabled'
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

query "eks_cluster_node_group_ssh_access_from_internet" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'remote_access') is null then 'ok'
        when (attributes_std -> 'remote_access' ->> 'ec2_ssh_key') is not null and (attributes_std -> 'remote_access' ->> 'source_security_group_ids') is not null then 'ok'
        when (attributes_std -> 'remote_access' ->> 'ec2_ssh_key') is not null and (attributes_std -> 'remote_access' ->> 'source_security_group_ids') is null then 'alarm'
        else 'alarm'
      end status,
      address || case
        when (attributes_std -> 'remote_access') is null then ' node group does not have implicit SSH access from 0.0.0.0/0'
        when (attributes_std -> 'remote_access' ->> 'ec2_ssh_key') is not null and (attributes_std -> 'remote_access' ->> 'source_security_group_ids') is not null then ' SSH access restricted to security group(s)'
        when (attributes_std -> 'remote_access' ->> 'ec2_ssh_key') is not null and (attributes_std -> 'remote_access' ->> 'source_security_group_ids') is null then ' has implicit SSH access from 0.0.0.0/0'
        else ' has implicit SSH access from 0.0.0.0/0'
        end || '.' reason
        ${local.tag_dimensions_sql}
        ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_eks_node_group';
  EOQ
}
