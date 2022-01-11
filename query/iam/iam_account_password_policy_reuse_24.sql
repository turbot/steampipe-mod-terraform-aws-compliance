select
  type || ' ' || name as resource,
  case
    when (arguments -> 'minimum_password_length') is null then 'skip' 
    when (arguments -> 'password_reuse_prevention') is null then 'alarm'
    when (arguments -> 'password_reuse_prevention')::integer >= 24 then 'ok'
    else 'alarm'
  end as status,
  name || case
    when (arguments -> 'minimum_password_length') is null then ' No password policy set'
    when (arguments -> 'password_reuse_prevention') is null then ' password reuse prevention not set'
    when (arguments -> 'password_reuse_prevention')::integer >= 24 then ' password reuse prevention set to ' || (arguments ->> 'password_reuse_prevention') || ' days'
    else ' password reuse prevention set to ' || (arguments ->> 'password_reuse_prevention') || ' days'
  end || '.' as reason,
  path
from
  terraform_resource
where
  type = 'aws_iam_account_password_policy';