select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'tracing_enabled')::boolean then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments ->> 'tracing_enabled')::boolean then ' X-Ray tracing enabled'
    else ' X-Ray tracing disabled'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'aws_api_gateway_stage';