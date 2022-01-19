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
      a.arguments ->> 'stage_name' as stage_name,
      a.type,
      a.name,
      a.path
    from stages_v1 as a left join method_settings as m on (m.arguments ->> 'rest_api_id') = (a.arguments ->> 'rest_api_id')
)
select
  type || ' ' || name as resource,
  caching_enabled,
  case
    when (caching_enabled)::boolean and (cache_data_encrypted)::boolean then 'ok'
    else 'alarm'
  end status,
  name || case
    when (caching_enabled)::boolean and (cache_data_encrypted)::boolean then ' API cache and encryption enabled'
    else ' API cache and encryption not enabled'
  end || '.' reason,
  path
from
  all_stages;