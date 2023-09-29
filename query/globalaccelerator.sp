query "globalaccelerator_flow_logs_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'attributes') is null then 'alarm'
        when (attributes_std -> 'attributes' -> 'flow_logs_enabled') is null then 'alram'
        when (attributes_std -> 'attributes' -> 'flow_logs_enabled')::bool then 'ok'
        else 'alarm'
      end as status,
      address || case
        when (attributes_std -> 'attributes') is null then ' flow log disabled'
        when (attributes_std -> 'attributes' -> 'flow_logs_enabled') is null then ' flow log disabled'
        when (attributes_std -> 'attributes' -> 'flow_logs_enabled')::bool then ' flow log enabled'
        else ' flow log disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_globalaccelerator_accelerator';
  EOQ
}
