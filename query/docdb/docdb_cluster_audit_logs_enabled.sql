select
  type || ' ' || name as resource,
  case
    when (arguments -> 'enabled_cloudwatch_logs_exports') is null then 'alarm'
    when (arguments ->> 'enabled_cloudwatch_logs_exports')::jsonb <@ '["audit"]' then 'ok' 
    else 'alarm'
  end as status,
  name || case
    when (arguments -> 'enabled_cloudwatch_logs_exports') is null then ' logging not enabled'
    else ' logging enabled'
  end || '.' as reason,
  path
from
  terraform_resource
where
  type = 'aws_docdb_cluster';