query "apigateway_rest_api_stage_use_ssl_certificate" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'client_certificate_id') is null then 'alarm'
        else 'ok'
      end status,
      address || case
        when (attributes_std -> 'client_certificate_id') is null then ' does not use SSL certificate'
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
      address as resource,
      case
        when (attributes_std ->> 'tracing_enabled')::boolean then 'ok'
        else 'alarm'
      end status,
      address || case
        when (attributes_std ->> 'tracing_enabled')::boolean then ' X-Ray tracing enabled'
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
        m.attributes_std -> 'settings' ->> 'caching_enabled' as caching_enabled,
        m.attributes_std -> 'settings' ->> 'cache_data_encrypted' as cache_data_encrypted,
        a.*
      from stages_v1 as a
      left join method_settings as m on (m.attributes_std ->> 'rest_api_id') = (a.attributes_std ->> 'rest_api_id')
  )
  select
    address as resource,
    case
      when (caching_enabled)::boolean and (cache_data_encrypted)::boolean then 'ok'
      else 'alarm'
    end status,
    address || case
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
        m.attributes_std -> 'settings' ->> 'logging_level' as log_level,
        a.attributes_std ->> 'stage_name' as stage_name,
        a.type,
        a.name,
        a.address,
        a.path,
        a.start_line,
        a.attributes_std,
        a._ctx
      from stages_v1 as a
      left join method_settings as m on (m.attributes_std ->> 'rest_api_id') = (a.attributes_std ->> 'rest_api_id')
    ), all_stages as (
      select
        log_level,
        stage_name,
        type,
        name,
        address,
        path,
        start_line,
        attributes_std,
        _ctx
      from
        all_v1
      union
      select
        attributes_std -> 'default_route_settings' ->> 'logging_level' as log_level,
        attributes_std ->> 'name' as stage_name,
        type,
        name,
        address,
        path,
        start_line,
        attributes_std,
        _ctx
      from
        terraform_resource
      where
        type = 'aws_apigatewayv2_stage'
  )
  select
    address as resource,
    case
      when log_level is null or log_level = 'OFF' then 'alarm'
      else 'ok'
    end status,
    address || case
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
      address as resource,
      case
        when (lifecycle ->> 'create_before_destroy') = 'true' then 'ok'
        else 'alarm'
      end status,
      address || case
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
      address as resource,
      case
        when (lifecycle ->> 'create_before_destroy') = 'true' then 'ok'
        else 'alarm'
      end status,
      address || case
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
      address as resource,
      case
        when (attributes_std -> 'settings' ->> 'caching_enabled') = 'true' then 'ok'
        else 'alarm'
      end status,
      address || case
        when (attributes_std -> 'settings' ->> 'caching_enabled') = 'true' then ' caching enabled'
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
      address as resource,
      case
        when (attributes_std -> 'settings' ->> 'cache_data_encrypted') = 'true' then 'ok'
        else 'alarm'
      end status,
      address || case
        when (attributes_std -> 'settings' ->> 'cache_data_encrypted') = 'true' then ' cache encryption enabled'
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
      address as resource,
      case
        when (attributes_std -> 'settings' ->> 'data_trace_enabled') = 'true' then 'alarm'
        else 'ok'
      end status,
      address || case
        when (attributes_std -> 'settings' ->> 'data_trace_enabled') = 'true' then ' data trace enabled'
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
      address as resource,
      case
        when (attributes_std ->> 'authorization_type') in ('AWS_IAM', 'CUSTOM', 'JWT') then 'ok'
        else 'alarm'
      end status,
      address || case
        when (attributes_std ->> 'authorization_type') in ('AWS_IAM', 'CUSTOM', 'JWT') then ' defines an authorization type'
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
      address as resource,
      case
        when (attributes_std ->> 'http_method') != 'OPTIONS' and (attributes_std ->> 'authorization') = 'NONE' and (attributes_std ->> 'api_key_required') is null then 'alarm'
        when (attributes_std ->> 'http_method') != 'OPTIONS' and (attributes_std ->> 'authorization') = 'NONE' and (attributes_std ->> 'api_key_required') = 'false' then 'alarm'
        else 'ok'
      end status,
      address || case
        when (attributes_std ->> 'http_method') != 'OPTIONS' and (attributes_std ->> 'authorization') = 'NONE' and (attributes_std ->> 'api_key_required') is null then ' does not restrict open access'
        when (attributes_std ->> 'http_method') != 'OPTIONS' and (attributes_std ->> 'authorization') = 'NONE' and (attributes_std ->> 'api_key_required') = 'false' then ' does not restrict open access'
        else ' is restrictive with http_method as ' || (attributes_std ->> 'http_method') || ', authorization as ' || (attributes_std ->> 'authorization') || ' and api_key_required as ' || (attributes_std ->> 'api_key_required')
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
      address as resource,
      case
        when (attributes_std ->> 'security_policy') is null or (attributes_std ->> 'security_policy') = 'TLS_1_2' then 'ok'
        else 'alarm'
      end status,
      address || case
        when (attributes_std ->> 'security_policy') is null or (attributes_std ->> 'security_policy') = 'TLS_1_2' then ' uses latest TLS security policy'
        else ' does not use latest TLS security policy'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_api_gateway_domain_name';
  EOQ
}