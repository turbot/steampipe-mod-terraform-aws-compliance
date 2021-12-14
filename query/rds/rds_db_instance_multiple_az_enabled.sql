select
  type || ' ' || name as resource,
  case
    when (arguments -> 'multi_az') is null then 'alarm'
    when (arguments -> 'multi_az')::bool then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'multi_az') is null then ' ''multi_az'' disabled'
    when (arguments -> 'multi_az')::bool then ' ''multi_az'' enabled'
    else '  ''multi_az'' disabled'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'aws_db_instance';