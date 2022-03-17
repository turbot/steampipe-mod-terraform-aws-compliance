select
  type || ' ' || name as resource,
  case
    when (arguments -> 'tracing_config') is null then 'alarm'
    when (arguments -> 'tracing_config' ->> 'mode') = 'Active' then 'ok'
    else 'alarm'
  end as status,
  name || case
    when (arguments -> 'tracing_config') is null then ' has X-Ray tracing disabled'
    when (arguments -> 'tracing_config' ->> 'mode') = 'Active' then ' has X-Ray tracing enabled'
    else  ' has X-Ray tracing disabled'
  end || '.' as reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'aws_lambda_function';