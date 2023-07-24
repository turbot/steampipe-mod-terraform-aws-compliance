query "backup_vault_encryption_at_rest_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'kms_key_arn') is null then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'kms_key_arn') is null then ' encryption at rest not enabled'
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
      type || ' ' || name as resource,
      case
        when (arguments -> 'rule') is null then 'alarm'
        when (arguments -> 'rule' -> 'lifecycle') is null then 'ok'
        when (arguments -> 'rule' -> 'lifecycle' ->> 'delete_after')::int >=35 then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'rule') is null then ' retention period not set'
        when (arguments -> 'rule' -> 'lifecycle') is null then ' retention period set to never expire'
        else ' retention period set to ' || (arguments -> 'rule' -> 'lifecycle' ->> 'delete_after')::int
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_backup_plan';
  EOQ
}