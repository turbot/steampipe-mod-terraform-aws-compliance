select
  type || ' ' || name as resource,
  case
    when (arguments -> 'enabled_cluster_log_types') is null then 'alarm'
    else 'ok'
  end as status,
  name || case
    when (arguments -> 'enabled_cluster_log_types') is null then ' logging disabled'
    else ' logging enabled'
  end || '.' as reason,
  path
from
  terraform_resource
where
  type = 'aws_eks_cluster';