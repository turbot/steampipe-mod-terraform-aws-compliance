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
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_backup_plan';
  EOQ
}