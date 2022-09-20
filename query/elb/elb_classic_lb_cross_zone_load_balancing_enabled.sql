select
  type || ' ' || name as resource,
  case
    when (arguments -> 'cross_zone_load_balancing') is null then 'ok'
    when (arguments -> 'cross_zone_load_balancing')::boolean then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'cross_zone_load_balancing') is null then ' cross-zone load balancing enabled'
    when (arguments -> 'cross_zone_load_balancing')::boolean then ' cross-zone load balancing enabled'
    else ' cross-zone load balancing disabled'
    end || '.' reason,
    path,
    start_line,
    end_line,
    source
from
  terraform_resource
where
  type = 'aws_elb'