select
  type || ' ' || name as resource,
  case
    when (arguments -> 'logging') is null then 'alarm'
    when (arguments -> 'logging' ->> 'enabled')::boolean then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'logging') is null then ' audit logging disabled'
    when (arguments -> 'logging' ->> 'enabled')::boolean then ' audit logging enabled'
    else ' audit logging disabled'
  end || '.' as reason,
  path,
  start_line,
  end_line,
  source
from
  terraform_resource
where
  type = 'aws_redshift_cluster';
