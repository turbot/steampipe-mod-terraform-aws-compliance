select
  type || ' ' || name as resource,
  case
    when (arguments -> 'description') is null then 'alarm'
    else 'ok'
  end status,
  name || case
    when (arguments -> 'description') is null then ' no description defined'
    else ' description defined'
  end || '.' reason,
  path,
  start_line,
  end_line,
  source
from
  terraform_resource
where
  type = 'aws_security_group_rule';