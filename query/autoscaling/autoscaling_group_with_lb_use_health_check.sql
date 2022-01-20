select
  type || ' ' || name as resource,
  case
    when (arguments -> 'load_balancers') is null and (arguments -> 'target_group_arns') is null then 'alarm'
    when (arguments ->> 'health_check_type') <> 'ELB' then 'alarm'
    else 'ok'
  end status,
  name || case
    when (arguments -> 'load_balancers') is null and (arguments -> 'target_group_arns') is null then ' not associated with a load balancer'
    when (arguments ->> 'health_check_type') <> 'ELB' then ' does not use ELB health check'
    else ' uses ELB health check'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'aws_autoscaling_group';