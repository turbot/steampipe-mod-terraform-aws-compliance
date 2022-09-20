select
  type || ' ' || name as resource,
  case
    when  (arguments ->> 'monitoring')::bool is true then 'ok'
    else 'alarm'
  end as status,
  name || case
    when  (arguments ->> 'monitoring')::bool is true then ' detailed monitoring enabled'
    else ' detailed monitoring disabled'
  end || '.' as reason,
  path,
  start_line,
  end_line,
  source
from
  terraform_resource
where
  type = 'aws_instance';