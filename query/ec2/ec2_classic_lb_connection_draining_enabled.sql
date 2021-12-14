select
  type || ' ' || name as resource,
  case
    when (arguments -> 'connection_draining') is null then 'alarm'
    when (arguments -> 'connection_draining')::bool then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'connection_draining') is null then ' ''connection_draining'' disabled'
    when (arguments -> 'connection_draining')::bool then ' ''connection_draining'' enabled'
    else ' ''connection_draining'' disabled'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'aws_elb';