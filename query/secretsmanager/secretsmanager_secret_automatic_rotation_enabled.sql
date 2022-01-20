select
  type || ' ' || name as resource,
  case
    when (arguments -> 'rotation_rules') is null then 'alarm'
    else 'ok'
  end as status,
  name || case
    when (arguments -> 'rotation_rules') is null then ' automatic rotation disabled'
    else ' automatic rotation enabled'
  end || '.' as reason,
  path
from
  terraform_resource
where
  type = 'aws_secretsmanager_secret';