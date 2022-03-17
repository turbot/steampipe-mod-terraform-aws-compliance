select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'source_type') <> 'db-security-group' then 'skip'
    when
      (arguments ->> 'source_type') = 'db-security-group'
      and (arguments -> 'enabled')::bool
      and (arguments -> 'event_categories_list')::jsonb @> '["failure", "configuration change"]'::jsonb
      and (arguments -> 'event_categories_list')::jsonb <@ '["failure", "configuration change"]'::jsonb then 'ok'
    else 'alarm'
  end as status,
  name || case
    when (arguments ->> 'source_type') <> 'db-security-group' then ' event subscription of ' || (arguments ->> 'source_type') || ' type'
    when
      (arguments ->> 'source_type') = 'db-security-group'
      and (arguments -> 'enabled')::bool and (arguments -> 'event_categories_list')::jsonb @> '["failure", "configuration change"]'::jsonb
      and (arguments -> 'event_categories_list')::jsonb <@ '["failure", "configuration change"]'::jsonb then ' event subscription enabled for critical database security group events'
    else ' event subscription missing critical database security group events'
  end || '.' as reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'aws_db_event_subscription';
