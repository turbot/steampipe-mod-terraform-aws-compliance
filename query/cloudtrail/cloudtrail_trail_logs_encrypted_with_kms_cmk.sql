select
  type || ' ' || name as resource,
  case
    when (arguments -> 'kms_key_id') is not null then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'kms_key_id') is not null then ' logs are encrypted at rest'
    else ' logs are not encrypted at rest'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'aws_cloudtrail';