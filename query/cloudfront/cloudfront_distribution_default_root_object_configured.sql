select
  type || ' ' || name as resource,
  case
    when (arguments -> 'default_root_object') is not null then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'default_root_object') is not null then ' default root object configured'
    else ' default root object not configured'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'aws_cloudfront_distribution';