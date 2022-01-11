-- TODO the following query will become irrelevant since the attributes rotation_rules and rotation_lambda_arn attributes have been deprecated
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
  path
from
  terraform_resource
where
  type = 'aws_secretsmanager_secret';