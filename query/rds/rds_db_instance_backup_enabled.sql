select
  type || ' ' || name as resource,
  case
    when (arguments -> 'backup_retention_period') is null then 'alarm'
    when (arguments -> 'backup_retention_period')::integer < 1 then 'alarm'
    else 'ok'
  end status,
  name || case
    when (arguments -> 'backup_retention_period') is null then ' backup disabled'
    when (arguments -> 'backup_retention_period')::integer < 1 then ' backup disabled'
    else ' backup enabled'
  end || '.' as reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'aws_db_instance';