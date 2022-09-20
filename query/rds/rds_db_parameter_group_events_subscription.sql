select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'source_type') <> 'db-parameter-group' then 'skip'
    when (arguments ->> 'source_type') = 'db-parameter-group' and (arguments -> 'enabled')::bool and (arguments -> 'event_categories_list')::jsonb @> '["failure", "maintenance"]'::jsonb and (arguments -> 'event_categories_list')::jsonb <@ '["failure", "maintenance"]'::jsonb then 'ok'
    else 'alarm'
  end as status,
  name || case
    when (arguments ->> 'source_type') <> 'db-parameter-group' then ' event subscription of ' || (arguments ->> 'source_type') || ' type'
    when (arguments ->> 'source_type') = 'db-parameter-group' and (arguments -> 'enabled')::bool and (arguments -> 'event_categories_list')::jsonb @> '["failure", "maintenance"]'::jsonb and (arguments -> 'event_categories_list')::jsonb <@ '["failure", "maintenance"]'::jsonb then ' event subscription enabled for critical database parameter group events'
    else ' event subscription missing critical database parameter group events'
  end || '.' as reason,
  path,
  start_line,
  end_line,
  source
from
  terraform_resource
where
  type = 'aws_db_event_subscription';