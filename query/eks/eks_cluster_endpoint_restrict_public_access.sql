select
  type || ' ' || name as resource,
  case
    when (arguments -> 'endpoint_public_access')::bool then 'alarm'
    else 'ok'
  end status,
  name || case
    when (arguments -> 'endpoint_public_access')::bool then ' endpoint publicly accessible'
    else ' endpoint not publicly accessible'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'aws_eks_cluster';