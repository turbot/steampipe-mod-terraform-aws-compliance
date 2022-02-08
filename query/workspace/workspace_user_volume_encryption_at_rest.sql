select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'root_volume_encryption_enabled')::boolean
    then 'ok'
    else 'alarm'
  end as status,
  name || case
    when (arguments ->> 'root_volume_encryption_enabled')::boolean
    then ' is encrypted'
    else ' is not encrypted'
  end || '.' as reason,
  path
from
  terraform_resource
where
  type = 'aws_workspaces_workspace';