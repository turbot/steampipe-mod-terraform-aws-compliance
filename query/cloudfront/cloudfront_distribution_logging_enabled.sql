select
  type || ' ' || name as resource,
  case
    when (arguments -> 'logging_config') is not null then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'logging_config') is not null then ' logging enabled'
    else ' logging disabled'
  end || '.' reason,
  path,
  start_line,
  end_line,
  source
from
  terraform_resource
where
  type = 'aws_cloudfront_distribution';