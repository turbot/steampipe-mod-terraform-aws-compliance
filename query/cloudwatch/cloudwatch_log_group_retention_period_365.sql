select
  type || ' ' || name as resource,
  case
    when (arguments -> 'retention_in_days') is null or (arguments -> 'retention_in_days')::int < 365 then 'alarm'
    else 'ok'
  end status,
  name || case
    when (arguments -> 'retention_in_days') is null then ' retention period not set'
    when (arguments -> 'retention_in_days')::int < 365 then ' retention period less than 365 days'
    else ' retention period 365 days or above'
  end || '.' reason,
  path,
  start_line,
  end_line,
  source
from
  terraform_resource
where
  type = 'aws_cloudwatch_log_group';