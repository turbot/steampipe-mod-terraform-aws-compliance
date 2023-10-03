query "guardduty_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'enable') is null then 'ok'
        when (attributes_std -> 'enable')::bool then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'enable') is null then ' guardduty enabled'
        when (attributes_std -> 'enable')::bool then ' guardduty enabled'
        else ' guardduty disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_guardduty_detector';
  EOQ
}
