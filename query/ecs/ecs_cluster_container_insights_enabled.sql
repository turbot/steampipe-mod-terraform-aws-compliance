select
  type || ' ' || name as resource,
  case
    when
      (arguments -> 'setting' ->> 'name')::text = 'containerInsights'
      and (arguments -> 'setting' ->> 'value')::text = 'enabled' then 'ok'
    else 'alarm'
  end as status,
  name || case
    when
      (arguments -> 'setting' ->> 'name')::text = 'containerInsights'
      and (arguments -> 'setting' ->> 'value')::text = 'enabled' then ' container insights enabled'
    else ' container insights disabled'
  end || '.' as reason,
  path
from
  terraform_resource
where
  type = 'aws_ecs_cluster';