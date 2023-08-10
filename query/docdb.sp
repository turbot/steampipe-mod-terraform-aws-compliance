query "docdb_cluster_audit_logs_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'enabled_cloudwatch_logs_exports') is null then 'alarm'
        when '"audit"' in (select jsonb_array_elements(arguments -> 'enabled_cloudwatch_logs_exports') from terraform_resource where type = 'aws_docdb_cluster') then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments -> 'enabled_cloudwatch_logs_exports') is null then ' logging not enabled'
        when '"audit"' in (select jsonb_array_elements(arguments -> 'enabled_cloudwatch_logs_exports') from terraform_resource where type = 'aws_docdb_cluster') then ' audit logging enabled'
        else ' audit logging not enabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_docdb_cluster';
  EOQ
}

query "docdb_cluster_encrypted_with_kms" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when
          (arguments ->> 'storage_encrypted')::boolean
          and coalesce(trim(arguments ->> 'kms_key_id'), '') <> ''
        then 'ok'
        else 'alarm'
      end as status,
      name || case
        when
          (arguments ->> 'storage_encrypted')::boolean
          and coalesce(trim(arguments ->> 'kms_key_id'), '') <> ''
        then ' encrypted at rest using customer-managed CMK'
        else ' not encrypted at rest using customer-managed CMK'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_docdb_cluster';
  EOQ
}

query "docdb_paramater_group_with_logging" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when
         (arguments -> 'parameter'->> 'name') = 'audit_logs'
         and (arguments -> 'parameter'->> 'value') = 'enabled'
        then 'ok'
        else 'alarm'
      end as status,
      name || case
        when
          (arguments -> 'parameter'->> 'name') = 'audit_logs'
          and (arguments -> 'parameter'->> 'value') = 'enabled'
        then ' paramarter group enabled with audit log'
        else ' not enabled with audit log'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_docdb_cluster_parameter_group';
  EOQ
}

query "docdb_global_cluster_encrypted" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when
          (arguments ->> 'storage_encrypted')::boolean
        then 'ok'
        else 'alarm'
      end as status,
      name || case
        when
          (arguments ->> 'storage_encrypted')::boolean
        then ' Global Cluster is encrypted'
        else ' Global Cluster is not encrypted'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_docdb_global_cluster';
  EOQ
}

query "docdb_log_exports_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when
         (arguments -> 'enabled_cloudwatch_logs_exports') is not null
        then 'ok'
        else 'alarm'
      end as status,
      name || case
        when
          (arguments -> 'enabled_cloudwatch_logs_exports') is not null
        then ' cloudwatch log exports enabled'
        else ' cloudwatch log exports disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_docdb_cluster';
  EOQ
}

query "docdb_tls_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when
         (arguments -> 'parameter'->> 'name') = 'tls'
         and (arguments -> 'parameter'->> 'value') = 'enabled'
        then 'ok'
        else 'alarm'
      end as status,
      name || case
        when
          (arguments -> 'parameter'->> 'name') = 'tls'
          and (arguments -> 'parameter'->> 'value') = 'enabled'
        then ' tls enabled'
        else ' tls disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_docdb_cluster_parameter_group';
  EOQ
}
