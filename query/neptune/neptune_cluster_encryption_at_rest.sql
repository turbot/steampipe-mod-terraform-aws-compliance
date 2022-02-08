select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'storage_encrypted')::boolean
    then 'ok'
    else 'alarm'
  end as status,
  name || case
    when (arguments ->> 'storage_encrypted')::boolean
    then ' is encrypted'
    else ' is not encrypted'
  end || '.' as reason,
  path
from
  terraform_resource
where
  type = 'aws_neptune_cluster';