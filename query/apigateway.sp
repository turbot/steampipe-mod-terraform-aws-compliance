query "apigateway_rest_api_stage_use_ssl_certificate" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'client_certificate_id') is null then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'client_certificate_id') is null then ' does not use SSL certificate'
        else ' uses SSL certificate'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_api_gateway_stage';
  EOQ
}

query "apigateway_rest_api_stage_xray_tracing_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'tracing_enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'tracing_enabled')::boolean then ' X-Ray tracing enabled'
        else ' X-Ray tracing disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_api_gateway_stage';
  EOQ
}

query "apigateway_stage_cache_encryption_at_rest_enabled" {
  sql = <<-EOQ
    with stages_v1 as (
      select
        *
      from
        terraform_resource
      where
        type = 'aws_api_gateway_stage'
    ), method_settings as (
        select
          *
        from
          terraform_resource
        where
          type = 'aws_api_gateway_method_settings'
    ), all_stages as (
      select
        m.arguments -> 'settings' ->> 'caching_enabled' as caching_enabled,
        m.arguments -> 'settings' ->> 'cache_data_encrypted' as cache_data_encrypted,
        a.*
      from stages_v1 as a
      left join method_settings as m on (m.arguments ->> 'rest_api_id') = (a.arguments ->> 'rest_api_id')
  )
  select
    type || ' ' || name as resource,
    case
      when (caching_enabled)::boolean and (cache_data_encrypted)::boolean then 'ok'
      else 'alarm'
    end status,
    name || case
      when (caching_enabled)::boolean and (cache_data_encrypted)::boolean then ' API cache and encryption enabled'
      else ' API cache and encryption not enabled'
    end || '.' reason
    ${local.tag_dimensions_sql}
    ${local.common_dimensions_sql}
  from
    all_stages;
  EOQ
}

query "apigateway_stage_logging_enabled" {
  sql = <<-EOQ
    with stages_v1 as (
      select
        *
      from
        terraform_resource
      where
        type = 'aws_api_gateway_stage'
    ), method_settings as (
      select
        *
      from
        terraform_resource
      where
        type = 'aws_api_gateway_method_settings'
    ), all_v1 as (
      select
        m.arguments -> 'settings' ->> 'logging_level' as log_level,
        a.arguments ->> 'stage_name' as stage_name,
        a.type,
        a.name,
        a.path,
        a.start_line,
        a.arguments,
        a._ctx
      from stages_v1 as a
      left join method_settings as m on (m.arguments ->> 'rest_api_id') = (a.arguments ->> 'rest_api_id')
    ), all_stages as (
      select
        log_level,
        stage_name,
        type,
        name,
        path,
        start_line,
        arguments,
        _ctx
      from
        all_v1
      union
      select
        arguments -> 'default_route_settings' ->> 'logging_level' as log_level,
        arguments ->> 'name' as stage_name,
        type,
        name,
        path,
        start_line,
        arguments,
        _ctx
      from
        terraform_resource
      where
        type = 'aws_apigatewayv2_stage'
  )
  select
    type || ' ' || name as resource,
    case
      when log_level is null or log_level = 'OFF' then 'alarm'
      else 'ok'
    end status,
    name || case
      when log_level is null or log_level = 'OFF' then ' logging disabled'
      else ' logging enabled'
    end || '.' reason
    ${local.tag_dimensions_sql}
    ${local.common_dimensions_sql}
  from
    all_stages;
  EOQ
}

query "aws_api_gateway_method_settings_cache_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'settings' ->> 'caching_enabled') = 'true' then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'settings' ->> 'caching_enabled') = 'true' then ' caching enabled'
        else ' caching disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_api_gateway_method_settings';
  EOQ
}

query "aws_api_gateway_method_settings_cache_encrypted" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'settings' ->> 'cache_data_encrypted') = 'true' then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'settings' ->> 'cache_data_encrypted') = 'true' then ' cache encryption enabled'
        else ' cache encryption disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_api_gateway_method_settings';
  EOQ
}

query "aws_api_gateway_method_settings_data_trace_enabled" {
    sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'settings' ->> 'data_trace_enabled') = 'true' then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'settings' ->> 'data_trace_enabled') = 'true' then ' data trace enabled'
        else ' data trace disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_api_gateway_method_settings';
  EOQ
}