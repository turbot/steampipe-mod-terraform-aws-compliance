select
  type || ' ' || name as resource,
  case
    when coalesce(trim(lower(arguments -> 'versioning' ->> 'enabled')), '') in ('true', 'false') and (arguments -> 'versioning' -> 'enabled')::bool 
    then 'ok'
    else 'alarm'
  end status,
  name || case
    when coalesce(trim(lower(arguments -> 'versioning' -> 'enabled')), '') not in ('true', 'false')
    then ' ''enabled'' is not defined'
    when (arguments -> 'versioning' -> 'enabled')::bool then ' versioning enabled.'
    else ' versioning disabled'
  end || '.' as reason,
  path
from
  terraform_resource
where
  type = 'aws_s3_bucket';