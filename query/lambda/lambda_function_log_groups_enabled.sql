select
  type || ' ' || name as resource,
  case
    when depends_on is null then 'alarm'
    when depends_on
    when (arguments -> 'tracing_config' ->> 'mode') = 'Active' then 'ok'
    else 'alarm'
  end as status,
  name || case
    when depends_on is null then 'alarm'
    when (arguments -> 'depends_on') is null then ' does not have an explicit log group' 
    when (arguments -> 'tracing_config' ->> 'mode') = 'Active' then ' has X-Ray tracing enabled'
    else  ' has X-Ray tracing disabled'
  end || '.' as reason,
  path
from
  terraform_resource
where
  type = 'aws_lambda_function';