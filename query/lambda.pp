query "lambda_function_concurrent_execution_limit_configured" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'reserved_concurrent_executions') is null then 'alarm'
        when (attributes_std -> 'reserved_concurrent_executions')::integer = -1 then 'alarm'
        else 'ok'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'reserved_concurrent_executions') is null then ' function-level concurrent execution limit not configured'
        when (attributes_std -> 'reserved_concurrent_executions')::integer = -1 then ' function-level concurrent execution limit not configured'
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
      address as resource,
      case
        when (attributes_std -> 'dead_letter_config') is null then 'alarm'
        else 'ok'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'dead_letter_config') is null then ' not configured with dead-letter queue'
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
      address as resource,
      case
        when (attributes_std -> 'vpc_config') is null then 'alarm'
        else 'ok'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'vpc_config') is null then ' is not in VPC'
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
      address as resource,
      case
        when (attributes_std ->> 'runtime') is null then 'skip'
        when (attributes_std ->> 'runtime') in ('nodejs14.x', 'nodejs12.x', 'nodejs10.x', 'python3.8', 'python3.7', 'python3.6', 'ruby2.5', 'ruby2.7', 'java11', 'java8', 'go1.x', 'dotnetcore2.1', 'dotnetcore3.1') then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'runtime') is null then ' runtime not set'
        when (attributes_std ->> 'runtime') in ('nodejs14.x', 'nodejs12.x', 'nodejs10.x', 'python3.8', 'python3.7', 'python3.6', 'ruby2.5', 'ruby2.7', 'java11', 'java8', 'go1.x', 'dotnetcore2.1', 'dotnetcore3.1') then ' uses latest runtime - ' || (attributes_std ->> 'runtime') || '.'
        else ' uses ' || (attributes_std ->> 'runtime')|| ' which is not the latest version.'
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
      address as resource,
      case
        when (attributes_std -> 'tracing_config') is null then 'alarm'
        when (attributes_std -> 'tracing_config' ->> 'mode') = 'Active' then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'tracing_config') is null then ' has X-Ray tracing disabled'
        when (attributes_std -> 'tracing_config' ->> 'mode') = 'Active' then ' has X-Ray tracing enabled'
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
      address as resource,
      case
        when (attributes_std ->> 'authorization_type') = 'NONE' then 'alarm'
        else 'ok'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'authorization_type') = 'NONE' then ' URLs AuthType is not configured'
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
      address as resource,
      case
        when (attributes_std -> 'code_signing_config_arn') is null then 'alarm'
        else 'ok'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'code_signing_config_arn') is null then ' code signing not configured'
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
        distinct (address ) as name
      from
        terraform_resource
        join jsonb_each_text(attributes_std -> 'environment' -> 'variables') d on true
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
      r.address as resource,
      case
        when s.name is not null then 'alarm'
        else 'ok'
      end as status,
      split_part(r.address, '.', 2) || case
        when s.name is not null then ' has potential sensitive data'
        else ' has no sensitive data'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource as r
      left join function_vaiable_with_sensitive_data as s on s.name = r.address
    where
      r.type = 'aws_lambda_function';
  EOQ
}

query "lambda_function_environment_encryption_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'environment') is not null and (attributes_std -> 'kms_key_arn') is not null then 'ok'
        when (attributes_std -> 'environment') is not null and (attributes_std -> 'kms_key_arn') is null then 'alarm'
        when (attributes_std -> 'environment') is null and (attributes_std -> 'kms_key_arn') is null then 'skip'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'environment') is not null and (attributes_std -> 'kms_key_arn') is not null then ' environment encryption enabled'
        when (attributes_std -> 'environment') is not null and (attributes_std -> 'kms_key_arn') is null then ' environment encryption disabled'
        when (attributes_std -> 'environment') is null and (attributes_std -> 'kms_key_arn') is null then ' no environment exists'
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

query "lambda_permission_restricted_service_permission" {
  sql = <<-EOQ
    select
      address as resource,
      split_part((attributes_std ->> 'principal'), '.', 2),
      case
        when not (split_part((attributes_std ->> 'principal'), '.', 2) = 'amazonaws' and split_part((attributes_std ->> 'principal'), '.', 3)= 'com') then 'info'
        when split_part((attributes_std ->> 'principal'), '.', 2) = 'amazonaws'
          and split_part((attributes_std ->> 'principal'), '.', 3)= 'com'
          and ((attributes_std -> 'source_arn') is not null
            or (attributes_std -> 'source_account') is not null ) then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when not (split_part((attributes_std ->> 'principal'), '.', 2) = 'amazonaws' and split_part((attributes_std ->> 'principal'), '.', 3) = 'com') then ' principal not set as service'
        when split_part((attributes_std ->> 'principal'), '.', 2) = 'amazonaws'
          and split_part((attributes_std ->> 'principal'), '.', 3)= 'com'
          and ((attributes_std -> 'source_arn') is not null
            or (attributes_std -> 'source_account') is not null ) then ' permissions to AWS services restricted by SourceArn or SourceAccount'
        else  ' permissions to AWS services not restricted by SourceArn or SourceAccount'
      end || '.' as reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_lambda_permission';
  EOQ
}