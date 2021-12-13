select
  type || ' ' || name as resource,
  case
    when (arguments -> 'password_reuse_prevention')::integer >= 24 then 'ok'
    else 'alarm'
  end as status,
  name || case
    when arguments -> 'password_reuse_prevention' is null then ' ''password_reuse_prevention'' is not defined'
    when (arguments -> 'password_reuse_prevention')::integer >= 24 then ' ''password_reuse_prevention'' is set and greater than 24'
    else ' ''password_reuse_prevention'' is set and less than 24'
  end || '.' as reason,
  path
from
  terraform_resource
where
  type = 'aws_iam_account_password_policy';
