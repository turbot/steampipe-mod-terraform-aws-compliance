select
  type || ' ' || name as resource,
  case
    when (arguments -> 'map_public_ip_on_launch') is null then 'ok'
    when (arguments -> 'map_public_ip_on_launch')::bool then 'alarm'
    else 'ok'
  end status,
  name || case
    when (arguments -> 'map_public_ip_on_launch') is null then ' ''map_public_ip_on_launch'' disabled'
    when (arguments -> 'map_public_ip_on_launch')::bool then ' ''map_public_ip_on_launch'' enabled'
    else ' ''map_public_ip_on_launch'' disabled'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'aws_subnet';