select
  -- Required Columns
  type || ' ' || name as resource,
  case
    when coalesce(trim(arguments ->> 'vpc_id'), '') = '' then 'alarm'
    else 'ok'
  end as status,
  name || case
    when (arguments -> 'vpc_id') is null then ' ''vpc_id'' not defined'
    when coalesce(trim(arguments ->> 'vpc_id'), '') <> '' then ' flow logging enabled'
    else ' flow logging disabled'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'aws_flow_log';