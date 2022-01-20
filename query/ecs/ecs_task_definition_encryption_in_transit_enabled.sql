select
  type || ' ' || name as resource,
  case
    when (arguments -> 'volume' -> 'efs_volume_configuration' ->> 'transit_encryption')::text = 'ENABLED' then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'volume' -> 'efs_volume_configuration' ->> 'transit_encryption')::text = 'ENABLED' then ' encryption in transit enabled'
    else ' encryption in transit enabled disabled'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'aws_ecs_task_definition';