select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'is_multi_region_trail') is null or (arguments ->> 'is_multi_region_trail')::boolean = 'false' then 'alarm'
    when (arguments ->> 'enable_logging') is null or (arguments ->> 'enable_logging')::boolean = 'false' then 'alarm'
    when (arguments -> 'event_selector' ->> 'read_write_type')::text <> 'All' then 'alarm'
    else 'ok'
  end status,
  name || case
    when (arguments ->> 'is_multi_region_trail') is null or (arguments ->> 'is_multi_region_trail')::boolean = 'false' then ' multi region trails not enabled'
    when (arguments ->> 'enable_logging') is null or (arguments ->> 'enable_logging')::boolean = 'false' then ' logging disabled'
    when (arguments -> 'event_selector' ->> 'read_write_type')::text <> 'All' then ' not enbaled for all events'
    else ' logging enabled for ALL events'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'aws_cloudtrail';