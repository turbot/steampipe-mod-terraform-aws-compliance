select
  type || ' ' || name as resource,
  case
    when (arguments -> 'cluster_subnet_group_name') is not null then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'cluster_subnet_group_name') is not null then ' deployed inside VPC'
    else ' not deployed inside VPC'
  end || '.' as reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'aws_redshift_cluster';