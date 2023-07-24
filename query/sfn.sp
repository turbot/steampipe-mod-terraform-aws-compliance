query "sfn_state_machine_xray_tracing_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'tracing_configuration' ->> 'enabled') = 'true' then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments -> 'tracing_configuration' ->> 'enabled') = 'true' then ' has tracing enabled'
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
      type || ' ' || name as resource,
      case
        when (arguments -> 'logging_configuration' ->> 'include_execution_data') = 'true' then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments -> 'logging_configuration' ->> 'include_execution_data') = 'true' then ' execution history logging enabled'
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
