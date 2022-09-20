select
  type || ' ' || name as resource,
  case
    when (arguments -> 'vpc_config') is null then 'alarm'
    else 'ok'
  end as status,
  name || case
    when (arguments -> 'vpc_config') is null then ' is not in VPC'
    else  ' is in VPC'
  end || '.' as reason,
  path,
  start_line,
  end_line,
  source
from
  terraform_resource
where
  type = 'aws_lambda_function';