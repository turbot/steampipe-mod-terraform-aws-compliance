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

query "lambda_function_url_auth_type_configured" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'authorization_type') = 'NONE' then 'alarm'
        else 'ok'
      end as status,
      name || case
        when (arguments ->> 'authorization_type') = 'NONE' then ' URLs AuthType is not configured'
        else ' URLs AuthType is configured'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_lambda_function_url';
  EOQ
}

query "lambda_function_code_signing_configured" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'code_signing_config_arn') is null then 'alarm'
        else 'ok'
      end as status,
      name || case
        when (arguments -> 'code_signing_config_arn') is null then ' code signing not configured'
        else ' code signing is configured'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_lambda_function';
  EOQ
}

query "lambda_function_variables_no_sensitive_data" {
  sql = <<-EOQ
    with function_vaiable_with_sensitive_data as (
      select
        distinct (type || ' ' || name ) as name
      from
        terraform_resource
        join jsonb_each_text(arguments -> 'environment' -> 'variables') d on true
      where
        type = 'aws_lambda_function'
        and (
          d.key ilike any (array['%pass%', '%secret%', '%token%', '%key%'])
          or d.key ~ '(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]'
          or d.value ilike any (array['%pass%', '%secret%', '%token%', '%key%'])
          or d.value ~ '(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]'
      )
    )
    select
      r.type || ' ' || r.name as resource,
      case
        when s.name is not null then 'alarm'
        else 'ok'
      end as status,
      r.name || case
        when s.name is not null then ' has potential sensitive data'
        else ' has no sensitive data'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource as r
      left join function_vaiable_with_sensitive_data as s on s.name = concat(r.type || ' ' || r.name)
    where
      r.type = 'aws_lambda_function';
  EOQ
}

query "lambda_function_environment_encryption_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'environment') is not null and (arguments -> 'kms_key_arn') is not null then 'ok'
        when (arguments -> 'environment') is not null and (arguments -> 'kms_key_arn') is null then 'alarm'
        when (arguments -> 'environment') is null and (arguments -> 'kms_key_arn') is null then 'skip'
        else 'alarm'
      end as status,
      name || case
        when (arguments -> 'environment') is not null and (arguments -> 'kms_key_arn') is not null then ' environment encryption enabled'
        when (arguments -> 'environment') is not null and (arguments -> 'kms_key_arn') is null then ' environment encryption disabled'
        when (arguments -> 'environment') is null and (arguments -> 'kms_key_arn') is null then ' no environment exist'
        else ' encryption is enabled even though no environment exists'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_lambda_function';
  EOQ
}
