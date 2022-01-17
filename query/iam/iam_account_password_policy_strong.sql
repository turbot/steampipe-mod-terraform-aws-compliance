select
  type || ' ' || name as resource,
  case
    when 
      (arguments -> 'minimum_password_length')::integer >= 14 
      and (arguments -> 'require_lowercase_characters')::bool
      and (arguments -> 'require_uppercase_characters')::bool
      and (arguments -> 'require_numbers')::bool
      and (arguments -> 'require_symbols')::bool
      and (arguments -> 'password_reuse_prevention')::integer >= 24
    then 'ok'
    else 'alarm'
  end as status,
  name || case
    when
      (arguments -> 'minimum_password_length')::integer >= 14 
      and (arguments -> 'require_lowercase_characters')::bool
      and (arguments -> 'require_uppercase_characters')::bool
      and (arguments -> 'require_numbers')::bool
      and (arguments -> 'require_symbols')::bool
      and (arguments -> 'password_reuse_prevention')::integer >= 24
    then ' Strong password policies configured'
    else ' Strong password policies not configured'
  end || '.' as reason,
  path
from
  terraform_resource
where
  type = 'aws_iam_account_password_policy';
