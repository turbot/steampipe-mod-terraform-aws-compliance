select
  type || ' ' || name as resource,
  case
    when (arguments -> 'configuration' -> 'result_configuration' -> 'encryption_configuration') is not null
    then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'configuration' -> 'result_configuration' -> 'encryption_configuration') is not null
    then ' encrypted at rest'
    else ' not encrypted at rest'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'aws_athena_workgroup';