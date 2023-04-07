query "guardduty_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'enable') is null then 'ok'
        when (arguments -> 'enable')::bool then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments -> 'enable') is null then ' guardduty enabled'
        when (arguments -> 'enable')::bool then ' guardduty enabled'
        else ' guardduty disabled'
      end || '.' as reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_guardduty_detector';
  EOQ
}
