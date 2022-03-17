select
  type || ' ' || name as resource,
  case
    when (arguments -> 'enable_cloudwatch_logs_exports') is null then 'alarm'
    else 'ok'
  end as status,
  name || case
    when (arguments -> 'enable_cloudwatch_logs_exports') is null then ' logging not enabled'
    else ' logging enabled'
  end || '.' as reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'aws_neptune_cluster';