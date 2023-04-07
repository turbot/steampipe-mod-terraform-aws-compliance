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
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_docdb_cluster';
  EOQ
}