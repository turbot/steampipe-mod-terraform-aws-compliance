select
  -- Required Columns
  type || ' ' || name as resource,
  case
    when coalesce(trim(arguments ->> 'vpc_id'), '') = '' then 'alarm'
    else 'ok'
  end as status,
  name || case
    when coalesce(trim(arguments ->> 'vpc_id'), '') = '' then ' ''vpc_id'' not defined.'
    when trim(arguments ->> 'vpc_id') <> '' then ' flow logging enabled.'
    else ' flow logging disabled.'
  end as reason,
  path
from
  terraform_resource
where
  type = 'aws_flow_log';