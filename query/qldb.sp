query "qldb_ledger_deletion_protection_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'deletion_protection') is null or (attributes_std ->> 'deletion_protection')::bool then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'deletion_protection') is null or (attributes_std ->> 'deletion_protection')::bool then ' deletion protection enabled'
        else ' deletion protection disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_qldb_ledger';
  EOQ
}

query "qldb_ledger_permission_mode_set_to_standard" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'permissions_mode') = 'STANDARD' then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'permissions_mode') = 'STANDARD' then ' permission mode set to "STANDARD"'
        else ' permission mode set to "ALLOW_ALL"'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_qldb_ledger';
  EOQ
}