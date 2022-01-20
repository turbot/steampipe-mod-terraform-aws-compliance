select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'transit_encryption_enabled')::boolean then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments ->> 'transit_encryption_enabled')::boolean then ' encrypted in transit'
    else ' not encrypted in transit'
  end || '.' as reason,
  path
from
  terraform_resource
where
  type = 'aws_elasticache_replication_group';