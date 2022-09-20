select
  type || ' ' || name as resource,
  case
    when (arguments -> 'origin_group' -> 'member') is not null then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'origin_group' -> 'member' ) is not null then ' origin group is configured'
    else ' origin group not configured'
  end || '.' reason,
  path,
  start_line,
  end_line,
  source
from
  terraform_resource
where
  type = 'aws_cloudfront_distribution';