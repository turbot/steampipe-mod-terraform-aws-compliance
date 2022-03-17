select
  type || ' ' || name as resource,
  case
    when (arguments -> 'snapshot_retention_limit')::int < 15 then 'alarm'
    else 'ok'
  end status,
  name || case
     when (arguments -> 'snapshot_retention_limit')::int is null then ' automatic backups disabled'
    when (arguments -> 'snapshot_retention_limit')::int < 15 then ' automatic backup retention period is less than 15 days'
    else ' automatic backup retention period is more than 15 days'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'aws_elasticache_replication_group';