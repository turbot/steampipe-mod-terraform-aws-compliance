select
  type || ' ' || name as resource,
  case
    when (arguments -> 'reserved_concurrent_executions') is null then 'alarm'
    when (arguments -> 'reserved_concurrent_executions')::integer = -1 then 'alarm'
    else 'ok'
  end as status,
  name || case
    when (arguments -> 'reserved_concurrent_executions') is null then ' function-level concurrent execution limit not configured'
    when (arguments -> 'reserved_concurrent_executions')::integer = -1 then ' function-level concurrent execution limit not configured'
    else ' function-level concurrent execution limit configured'
  end || '.' as reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'aws_lambda_function';