select
  type || ' ' || name as resource,
  case
    when (arguments -> 'alarm_actions') is null
    and (arguments -> 'insufficient_data_actions') is null
    and (arguments -> 'ok_actions') is null then 'alarm'
    else 'ok'
  end status,
  name || case
    when (arguments -> 'alarm_actions') is null
    and (arguments -> 'insufficient_data_actions') is null
    and (arguments -> 'ok_actions') is null then ' no action enabled'
    when (arguments -> 'alarm_actions') is not null then ' alarm action enabled'
    when (arguments -> 'insufficient_data_actions') is not null then ' insufficient data action enabled.'
    when (arguments -> 'ok_actions') is not null then ' ok action enabled.'
    else 'ok'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'aws_cloudwatch_metric_alarm';