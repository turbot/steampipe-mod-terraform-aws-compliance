select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'root_volume_encryption_enabled')::boolean then 'ok'
    else 'alarm'
  end as status,
  name || case
    when (arguments ->> 'root_volume_encryption_enabled')::boolean then ' encrypted at rest'
    else ' not encrypted at rest'
  end || '.' as reason,
  path,
  start_line,
  end_line,
  source
from
  terraform_resource
where
  type = 'aws_workspaces_workspace';