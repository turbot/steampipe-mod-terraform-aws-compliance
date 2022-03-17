select
  type || ' ' || name as resource,
  case
    when (arguments -> 'rotation_rules') is not null and (arguments -> 'rotation_lambda_arn') is not null then 'ok'
    else 'alarm'
  end as status,
  name || case
    when (arguments -> 'rotation_rules') is not null and (arguments -> 'rotation_lambda_arn') is not null then ' scheduled for rotation using Lambda function'
    else ' automatic rotation using Lambda function disabled'
  end || '.' as reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'aws_secretsmanager_secret';