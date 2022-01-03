-- TODO the following query will become irrelevant since the attributes rotation_rules attribute has been deprecated
select
  type || ' ' || name as resource,
  case
    when (arguments -> 'rotation_rules') is null then 'alarm'
    else 'ok'
  end as status,
  name || case
    when (arguments -> 'rotation_rules') is null then ' automatic rotation not enabled'
    else ' automatic rotation enabled'
  end || '.' as reason,
  path
from
  terraform_resource
where
  type = 'aws_secretsmanager_secret';