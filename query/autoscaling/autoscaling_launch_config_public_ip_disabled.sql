select
  type || ' ' || name as resource,
  case
    when (arguments -> 'associate_public_ip_address')::boolean then 'alarm'
    else 'ok'
  end status,
  name || case
   when (arguments -> 'associate_public_ip_address')::boolean then ' public IP enabled'
    else ' public IP disabled'
  end || '.' reason,
  path,
  start_line,
  end_line,
  source
from
  terraform_resource
where
  type = 'aws_launch_configuration';