query "cloudformation_stack_notifications_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'notification_arns') is not null then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'notification_arns') is not null then ' notifications enabled'
        else ' notifications disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_cloudformation_stack';    
  EOQ
}