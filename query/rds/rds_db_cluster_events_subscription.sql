select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'source_type') <> 'db-cluster' then 'skip'
    when (arguments ->> 'source_type') = 'db-cluster' and (arguments -> 'enabled')::bool and (arguments -> 'event_categories_list')::jsonb @> '["failure", "maintenance"]'::jsonb and (arguments -> 'event_categories_list')::jsonb <@ '["failure", "maintenance"]'::jsonb then 'ok'
    else 'alarm'
  end as status,
  name || case
    when (arguments ->> 'source_type') <> 'db-cluster' then ' event subscription of ' || (arguments ->> 'source_type') || ' type'
    when (arguments ->> 'source_type') = 'db-cluster' and (arguments -> 'enabled')::bool and (arguments -> 'event_categories_list')::jsonb @> '["failure", "maintenance"]'::jsonb and (arguments -> 'event_categories_list')::jsonb <@ '["failure", "maintenance"]'::jsonb then ' event subscription enabled for critical db cluster events'
    else ' event subscription missing critical db cluster events'
  end || '.' as reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'aws_db_event_subscription';