select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'storage_encrypted')::boolean then 'ok'
    else 'alarm'
  end as status,
  name || case
    when (arguments ->> 'storage_encrypted')::boolean then ' encrypted at rest'
    else ' not encrypted at rest'
  end || '.' as reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'aws_neptune_cluster';