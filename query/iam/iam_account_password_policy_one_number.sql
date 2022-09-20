select
  type || ' ' || name as resource,
  case
    when (arguments -> 'require_numbers') is null then 'alarm' 
    when (arguments -> 'require_numbers')::bool then 'ok'
    else 'alarm'
  end as status,
  name || case
    when (arguments -> 'require_numbers') is null then ' number not set to required'
    when (arguments -> 'require_numbers')::bool then ' number set to required'
    else ' number not set to required'
  end || '.' as reason,
  path,
  start_line,
  end_line,
  source
from
  terraform_resource
where
  type = 'aws_iam_account_password_policy';