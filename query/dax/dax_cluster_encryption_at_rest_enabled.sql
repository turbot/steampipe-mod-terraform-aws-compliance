select
  type || ' ' || name as resource,
  case
    when (arguments -> 'server_side_encryption') is null then 'alarm'
    else 'ok'
  end status,
  name || case
    when (arguments -> 'server_side_encryption') is null then ' encryption at rest disabled'
    else ' encryption at rest disabled enabled'
  end || '.' as reason,
  path
from
  terraform_resource
where
  type = 'aws_dax_cluster';
