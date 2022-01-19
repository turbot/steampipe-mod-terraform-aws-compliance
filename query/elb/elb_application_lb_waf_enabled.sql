select
  type || ' ' || name as resource,
  case
    when (arguments -> 'enable_waf_fail_open') is null then 'alarm'
    when (arguments -> 'enable_waf_fail_open')::boolean then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'enable_waf_fail_open') is null then ' WAF disabled'
    when (arguments -> 'enable_waf_fail_open')::boolean then ' WAF enabled'
    else ' WAF disabled'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'aws_lb';