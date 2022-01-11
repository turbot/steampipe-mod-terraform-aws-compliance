select
  type || ' ' || name as resource,
  case
    when (arguments -> 'kms_key_id') is not null then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'kms_key_id') is not null then ' encrypted at rest'
    else ' not encrypted at rest'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'aws_cloudwatch_log_group';