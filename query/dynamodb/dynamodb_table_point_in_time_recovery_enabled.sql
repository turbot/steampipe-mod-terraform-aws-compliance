select
  type || ' ' || name as resource,
  case
    when (arguments -> 'point_in_time_recovery') is null then 'alarm'
    else 'ok'
  end status,
  name || case
    when (arguments -> 'point_in_time_recovery') is null then ' ''point_in_time_recovery'' disabled'
    else ' ''point_in_time_recovery'' enabled'
  end || '.' as reason,
  path
from
  terraform_resource
where
  type = 'aws_dynamodb_table';
