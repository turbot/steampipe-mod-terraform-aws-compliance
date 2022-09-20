select
  type || ' ' || name as resource,
  case
    when (arguments -> 'associate_public_ip_address') is null then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'associate_public_ip_address') is null then ' not publicly accessible'
    else ' publicly accessible'
  end || '.' reason,
  path,
  start_line,
  end_line,
  source
from
  terraform_resource
where
  type = 'aws_instance';