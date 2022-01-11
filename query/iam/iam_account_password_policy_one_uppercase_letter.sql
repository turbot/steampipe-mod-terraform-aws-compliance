select
  type || ' ' || name as resource,
  case
    when (arguments -> 'minimum_password_length') is null then 'skip' 
    when (arguments -> 'require_uppercase_characters')::bool then 'ok'
    else 'alarm'
  end as status,
  name || case
    when (arguments -> 'minimum_password_length') is null then ' No password policy set'
    when (arguments -> 'require_uppercase_characters')::bool then ' uppercase characters set to required'
    else ' uppercase characters not set to required'
  end || '.' as reason,
  path
from
  terraform_resource
where
  type = 'aws_iam_account_password_policy';