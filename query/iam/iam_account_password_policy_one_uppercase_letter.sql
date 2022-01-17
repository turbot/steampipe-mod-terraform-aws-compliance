select
  type || ' ' || name as resource,
  case
    when (arguments -> 'require_uppercase_characters') is null then 'alarm' 
    when (arguments -> 'require_uppercase_characters')::bool then 'ok'
    else 'alarm'
  end as status,
  name || case
    when (arguments -> 'require_uppercase_characters') is null then ' ''require_uppercase_characters'' not defined'
    when (arguments -> 'require_uppercase_characters')::bool then ' uppercase characters set to required'
    else ' uppercase characters not set to required'
  end || '.' as reason,
  path
from
  terraform_resource
where
  type = 'aws_iam_account_password_policy';