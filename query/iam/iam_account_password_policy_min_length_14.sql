select
  type || ' ' || name as resource,
  case
    when (arguments -> 'minimum_password_length') is null then 'alarm'
    when (arguments -> 'minimum_password_length')::integer >= 14 then 'ok'
    else 'alarm'
  end as status,
  name || case
    when (arguments -> 'minimum_password_length') is null then ' ''minimum_password_length'' is not defined'
    when (arguments -> 'minimum_password_length')::integer >= 14 then ' ''minimum_password_length'' is set and greater than 14'
    else ' ''minimum_password_length'' is set and less than 14'
  end || '.' as reason,
  path,
  start_line,
  end_line,
  source
from
  terraform_resource
where
  type = 'aws_iam_account_password_policy';