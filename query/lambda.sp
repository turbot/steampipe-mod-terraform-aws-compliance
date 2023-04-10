query "lambda_function_concurrent_execution_limit_configured" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'reserved_concurrent_executions') is null then 'alarm'
        when (arguments -> 'reserved_concurrent_executions')::integer = -1 then 'alarm'
        else 'ok'
      end as status,
      name || case
        when (arguments -> 'reserved_concurrent_executions') is null then ' function-level concurrent execution limit not configured'
        when (arguments -> 'reserved_concurrent_executions')::integer = -1 then ' function-level concurrent execution limit not configured'
        else ' function-level concurrent execution limit configured'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_lambda_function';
  EOQ
}

query "lambda_function_dead_letter_queue_configured" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'dead_letter_config') is null then 'alarm'
        else 'ok'
      end as status,
      name || case
        when (arguments -> 'dead_letter_config') is null then ' not configured with dead-letter queue'
        else ' configured with dead-letter queue'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_lambda_function';
  EOQ
}

query "lambda_function_in_vpc" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'vpc_config') is null then 'alarm'
        else 'ok'
      end as status,
      name || case
        when (arguments -> 'vpc_config') is null then ' is not in VPC'
        else ' is in VPC'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_lambda_function';
  EOQ
}

query "lambda_function_use_latest_runtime" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'runtime') is null then 'skip'
        when (arguments ->> 'runtime') in ('nodejs14.x', 'nodejs12.x', 'nodejs10.x', 'python3.8', 'python3.7', 'python3.6', 'ruby2.5', 'ruby2.7', 'java11', 'java8', 'go1.x', 'dotnetcore2.1', 'dotnetcore3.1') then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments ->> 'runtime') is null then ' runtime not set'
        when (arguments ->> 'runtime') in ('nodejs14.x', 'nodejs12.x', 'nodejs10.x', 'python3.8', 'python3.7', 'python3.6', 'ruby2.5', 'ruby2.7', 'java11', 'java8', 'go1.x', 'dotnetcore2.1', 'dotnetcore3.1') then ' uses latest runtime - ' || (arguments ->> 'runtime') || '.'
        else ' uses ' || (arguments ->> 'runtime')|| ' which is not the latest version.'
      end as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
    type = 'aws_lambda_function';
  EOQ
}

query "lambda_function_xray_tracing_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'tracing_config') is null then 'alarm'
        when (arguments -> 'tracing_config' ->> 'mode') = 'Active' then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments -> 'tracing_config') is null then ' has X-Ray tracing disabled'
        when (arguments -> 'tracing_config' ->> 'mode') = 'Active' then ' has X-Ray tracing enabled'
        else ' has X-Ray tracing disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_lambda_function';
  EOQ
}
