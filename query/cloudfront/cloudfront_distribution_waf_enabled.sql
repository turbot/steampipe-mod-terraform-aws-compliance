select
  type || ' ' || name as resource,
  case
    when (arguments -> 'web_acl_id') is not null then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'web_acl_id') is not null then ' associated with WAF'
    else ' not associated with WAF'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'aws_cloudfront_distribution';