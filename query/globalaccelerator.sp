query "globalaccelerator_flow_logs_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'attributes') is null then 'alarm'
        when (arguments -> 'attributes' -> 'flow_logs_enabled') is null then 'alram'
        when (arguments -> 'attributes' -> 'flow_logs_enabled')::bool then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments -> 'attributes') is null then ' flow log disabled'
        when (arguments -> 'attributes' -> 'flow_logs_enabled') is null then ' flow log disabled'
        when (arguments -> 'attributes' -> 'flow_logs_enabled')::bool then ' flow log enabled'
        else ' flow log disabled'
      end || '.' as reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_globalaccelerator_accelerator';
  EOQ
}
