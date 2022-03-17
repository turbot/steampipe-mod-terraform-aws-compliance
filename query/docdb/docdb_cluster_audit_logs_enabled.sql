select
  type || ' ' || name as resource,
  case
    when (arguments -> 'enabled_cloudwatch_logs_exports') is null then 'alarm'
    when '"audit"' in (select jsonb_array_elements(arguments -> 'enabled_cloudwatch_logs_exports') from terraform_resource where type = 'aws_docdb_cluster') then 'ok' 
    else 'alarm'
  end as status,
  name || case
    when (arguments -> 'enabled_cloudwatch_logs_exports') is null then ' logging not enabled'
    when '"audit"' in (select jsonb_array_elements(arguments -> 'enabled_cloudwatch_logs_exports') from terraform_resource where type = 'aws_docdb_cluster') then ' audit logging enabled'
    else ' audit logging not enabled'
  end || '.' as reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'aws_docdb_cluster';