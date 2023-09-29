query "docdb_cluster_audit_logs_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'enabled_cloudwatch_logs_exports') is null then 'alarm'
        when '"audit"' in (select jsonb_array_elements(attributes_std -> 'enabled_cloudwatch_logs_exports') from terraform_resource where type = 'aws_docdb_cluster') then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'enabled_cloudwatch_logs_exports') is null then ' logging not enabled'
        when '"audit"' in (select jsonb_array_elements(attributes_std -> 'enabled_cloudwatch_logs_exports') from terraform_resource where type = 'aws_docdb_cluster') then ' audit logging enabled'
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
      address as resource,
      case
        when
          (attributes_std ->> 'storage_encrypted')::boolean
          and coalesce(trim(attributes_std ->> 'kms_key_id'), '') <> ''
        then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when
          (attributes_std ->> 'storage_encrypted')::boolean
          and coalesce(trim(attributes_std ->> 'kms_key_id'), '') <> ''
        then ' encrypted at rest using KMS CMK'
        else ' not encrypted at rest using KMS CMK'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_docdb_cluster';
  EOQ
}

query "docdb_cluster_paramater_group_logging_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when
         (attributes_std -> 'parameter'->> 'name') = 'audit_logs'
         and (attributes_std -> 'parameter'->> 'value') = 'enabled'
        then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when
          (attributes_std -> 'parameter'->> 'name') = 'audit_logs'
          and (attributes_std -> 'parameter'->> 'value') = 'enabled'
        then ' logging enabled'
        else ' logging disabled'
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
      address as resource,
      case
        when
          (attributes_std ->> 'storage_encrypted')::boolean
        then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when
          (attributes_std ->> 'storage_encrypted')::boolean
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

query "docdb_cluster_log_exports_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when
         (attributes_std -> 'enabled_cloudwatch_logs_exports') is not null
        then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when
          (attributes_std -> 'enabled_cloudwatch_logs_exports') is not null
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

query "docdb_cluster_parameter_group_tls_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when
         (attributes_std -> 'parameter'->> 'name') = 'tls'
         and (attributes_std -> 'parameter'->> 'value') = 'enabled'
        then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when
          (attributes_std -> 'parameter'->> 'name') = 'tls'
          and (attributes_std -> 'parameter'->> 'value') = 'enabled'
        then ' TLS enabled'
        else ' TLS disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_docdb_cluster_parameter_group';
  EOQ
}
