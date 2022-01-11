select
  type || ' ' || name as resource,
  case
    when (arguments -> 'minimum_password_length') is null then 'skip' 
    when (arguments -> 'require_lowercase_characters')::bool then 'ok'
    else 'alarm'
  end as status,
  name || case
    when (arguments -> 'minimum_password_length') is null then ' No password policy set'
    when (arguments -> 'require_lowercase_characters')::bool then ' lowercase character set to required'
    else ' lowercase character not set to required'
  end || '.' as reason,
  path
from
  terraform_resource
where
  type = 'aws_iam_account_password_policy';
