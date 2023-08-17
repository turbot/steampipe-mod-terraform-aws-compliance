query "mwaa_environment_worker_logs_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'logging_configuration' -> 'worker_logs' ->> 'enabled')::boolean then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments -> 'logging_configuration' -> 'worker_logs' ->> 'enabled')::boolean then ' worker logs enabled'
        else ' worker logs disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_mwaa_environment';
  EOQ
}

query "mwaa_environment_webserver_logs_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'logging_configuration' -> 'webserver_logs' ->> 'enabled')::boolean then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments -> 'logging_configuration' -> 'webserver_logs' ->> 'enabled')::boolean then ' webserver logs enabled'
        else ' webserver logs disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_mwaa_environment';
  EOQ
}

query "mwaa_environment_scheduler_logs_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'logging_configuration' -> 'scheduler_logs' ->> 'enabled')::boolean then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments -> 'logging_configuration' -> 'scheduler_logs' ->> 'enabled')::boolean then ' scheduler logs enabled'
        else ' scheduler logs disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_mwaa_environment';
  EOQ
}