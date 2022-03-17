select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'enable_log_file_validation')::boolean then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments ->> 'enable_log_file_validation')::boolean then ' log file validation enabled'
    else ' log file validation disabled'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'aws_cloudtrail';