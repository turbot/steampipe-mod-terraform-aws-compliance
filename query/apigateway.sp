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

query "apigateway_rest_api_create_before_destroy_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (lifecycle ->> 'create_before_destroy') = 'true' then 'ok'
        else 'alarm'
      end status,
      name || case
        when (lifecycle ->> 'create_before_destroy') = 'true' then ' create before destroy enabled'
        else ' create before destroy disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_api_gateway_rest_api';
  EOQ
}

query "apigateway_deployment_create_before_destroy_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (lifecycle ->> 'create_before_destroy') = 'true' then 'ok'
        else 'alarm'
      end status,
      name || case
        when (lifecycle ->> 'create_before_destroy') = 'true' then ' create before destroy enabled'
        else ' create before destroy disabled'
      end || '.' reason
    from
      terraform_resource
    where
      type = 'aws_api_gateway_deployment';
  EOQ
}

query "apigateway_method_settings_cache_enabled" {
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

query "apigateway_method_settings_cache_encryption_enabled" {
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

query "apigateway_method_settings_data_trace_enabled" {
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

query "apigatewayv2_route_set_authorization_type" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'authorization_type') in ('AWS_IAM', 'CUSTOM', 'JWT') then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'authorization_type') in ('AWS_IAM', 'CUSTOM', 'JWT') then ' defines an authorization type'
        else ' does not define an authorization type'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_apigatewayv2_route';
  EOQ
}

query "apigateway_method_restricts_open_access" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'http_method') != 'OPTIONS' and (arguments ->> 'authorization') = 'NONE' and (arguments ->> 'api_key_required') is null then 'alarm'
        when (arguments ->> 'http_method') != 'OPTIONS' and (arguments ->> 'authorization') = 'NONE' and (arguments ->> 'api_key_required') = 'false' then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments ->> 'http_method') != 'OPTIONS' and (arguments ->> 'authorization') = 'NONE' and (arguments ->> 'api_key_required') is null then ' API Gateway method is not restricted'
        when (arguments ->> 'http_method') != 'OPTIONS' and (arguments ->> 'authorization') = 'NONE' and (arguments ->> 'api_key_required') = 'false' then ' API Gateway method is not restricted'
        else ' API Gateway method is restrictive with http_method as ' || (arguments ->> 'http_method') || ', authorization as ' || (arguments ->> 'authorization') || ' and api_key_required as ' || (arguments ->> 'api_key_required')
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_api_gateway_method';
  EOQ
}

query "apigateway_domain_name_use_latest_tls" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'security_policy') is null or (arguments ->> 'security_policy') = 'TLS_1_2' then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments ->> 'security_policy') is null or (arguments ->> 'security_policy') = 'TLS_1_2' then ' API Gateway Domain uses latest TLS security policy'
        else ' API Gateway Domain not using latest TLS security policy'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_api_gateway_domain_name';
  EOQ
}