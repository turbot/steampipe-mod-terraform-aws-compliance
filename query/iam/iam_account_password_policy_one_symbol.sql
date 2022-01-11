select
  type || ' ' || name as resource,
  case
    when (arguments -> 'minimum_password_length') is null then 'skip' 
    when (arguments -> 'require_symbols')::bool then 'ok'
    else 'alarm'
  end as status,
  name || case
    when (arguments -> 'minimum_password_length') is null then ' No password policy set'
    when (arguments -> 'require_symbols')::bool then ' symbol set to required'
    else ' symbol not set to required'
  end || '.' as reason,
  path
from
  terraform_resource
where
  type = 'aws_iam_account_password_policy';