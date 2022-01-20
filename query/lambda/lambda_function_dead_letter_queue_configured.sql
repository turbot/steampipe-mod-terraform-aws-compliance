select
  type || ' ' || name as resource,
  case
    when (arguments -> 'dead_letter_config') is null then 'alarm'
    else 'ok'
  end as status,
  name || case
    when (arguments -> 'dead_letter_config') is null then ' not configured with dead-letter queue'
    else  ' configured with dead-letter queue'
  end || '.' as reason,
  path
from
  terraform_resource
where
  type = 'aws_lambda_function';