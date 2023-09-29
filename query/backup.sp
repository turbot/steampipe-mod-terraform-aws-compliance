query "backup_vault_encryption_at_rest_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'kms_key_arn') is null then 'alarm'
        else 'ok'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'kms_key_arn') is null then ' encryption at rest disabled'
        else ' encryption at rest enabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_backup_vault';
  EOQ
}

query "backup_plan_min_retention_35_days" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'rule') is null then 'alarm'
        when (attributes_std -> 'rule' -> 'lifecycle') is null then 'ok'
        when (attributes_std -> 'rule' -> 'lifecycle' ->> 'delete_after')::int >=35 then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'rule') is null then ' retention period not set'
        when (attributes_std -> 'rule' -> 'lifecycle') is null then ' retention period set to never expire'
        else ' retention period set to ' || (attributes_std -> 'rule' -> 'lifecycle' ->> 'delete_after')::int
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_backup_plan';
  EOQ
}