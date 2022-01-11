select
  type || ' ' || name as resource,
  case
    when (arguments -> 'minimum_password_length') is null then 'skip' 
    when (arguments -> 'max_password_age') is null then 'alarm'
    when (arguments -> 'max_password_age')::integer <= 90 then 'ok'
    else 'alarm'
  end as status,
  name || case
    when (arguments -> 'minimum_password_length') is null then ' No password policy set'
    when (arguments -> 'max_password_age') is null then ' password expiration not set'
    when (arguments -> 'max_password_age')::integer <= 90 then ' password expiration set to ' || (arguments ->> 'max_password_age') || ' days'
    else ' password expiration set to ' || (arguments ->> 'max_password_age') || ' days'
  end || '.' as reason,
  path
from
  terraform_resource
where
  type = 'aws_iam_account_password_policy';