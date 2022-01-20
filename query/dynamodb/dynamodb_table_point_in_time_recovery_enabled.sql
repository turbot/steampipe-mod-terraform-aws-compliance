select
  type || ' ' || name as resource,
  case
    when (arguments -> 'point_in_time_recovery') is null then 'alarm'
    when (arguments -> 'point_in_time_recovery' ->> 'enabled')::boolean then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'point_in_time_recovery') is null then ' ''point_in_time_recovery'' disabled'
    when (arguments -> 'point_in_time_recovery' ->> 'enabled')::boolean then ' ''point_in_time_recovery'' enabled'
    else ' ''point_in_time_recovery'' disabled'
  end || '.' as reason,
  path
from
  terraform_resource
where
  type = 'aws_dynamodb_table';
