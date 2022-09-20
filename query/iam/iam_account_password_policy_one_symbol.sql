select
  type || ' ' || name as resource,
  case
    when (arguments -> 'require_symbols') is null then 'alarm'
    when (arguments -> 'require_symbols')::boolean then 'ok'
    else 'alarm'
  end as status,
  name || case
    when (arguments -> 'require_symbols') is null then ' symbol not set to required'
    when (arguments -> 'require_symbols')::boolean then ' symbol set to required'
    else ' symbol not set to required'
  end || '.' as reason,
  path,
  start_line,
  end_line,
  source
from
  terraform_resource
where
  type = 'aws_iam_account_password_policy';