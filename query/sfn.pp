query "sfn_state_machine_xray_tracing_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'tracing_configuration' ->> 'enabled') = 'true' then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'tracing_configuration' ->> 'enabled') = 'true' then ' has tracing enabled'
        else ' has tracing disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_sfn_state_machine';
  EOQ
}

query "sfn_state_machine_execution_history_logging_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'logging_configuration' ->> 'include_execution_data') = 'true' then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'logging_configuration' ->> 'include_execution_data') = 'true' then ' execution history logging enabled'
        else ' execution history logging disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_sfn_state_machine';
  EOQ
}
