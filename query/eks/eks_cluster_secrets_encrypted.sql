select
  type || ' ' || name as resource,
  case
    when (arguments -> 'encryption_config') is null then 'alarm'
    when (arguments -> 'encryption_config' -> 'resources') @> '["secrets"]' then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'encryption_config') is null then ' encryption disabled'
    when (arguments -> 'encryption_config' -> 'resources') @> '["secrets"]' then 'encrypted with EKS secrets'
    else ' not encrypted with EKS secrets'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'aws_eks_cluster';