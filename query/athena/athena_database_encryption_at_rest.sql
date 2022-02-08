select
  type || ' ' || name as resource,
  case
    when (arguments -> 'encryption_configuration') is not null then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'encryption_configuration') is null then ' is not encrypted'
    else ' is encrypted'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'aws_athena_database';