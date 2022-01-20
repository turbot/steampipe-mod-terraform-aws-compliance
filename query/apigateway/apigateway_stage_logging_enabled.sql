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
      a.path
    from stages_v1 as a left join method_settings as m on (m.arguments ->> 'rest_api_id') = (a.arguments ->> 'rest_api_id')
), all_stages as (
    select
      log_level, stage_name, type, name, path
    from
      all_v1
    union
    select
      arguments -> 'default_route_settings' ->> 'logging_level' as log_level,
      arguments ->>  'name' as stage_name,
      type,
      name,
      path
    from terraform_resource where type = 'aws_apigatewayv2_stage'
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
  end || '.' reason,
  path
from
  all_stages;