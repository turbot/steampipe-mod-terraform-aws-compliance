select
  type || ' ' || name as resource,
  case
    when  (arguments -> 'ebs_optimized')::bool is true then 'ok'
    else 'alarm'
  end as status,
  name || case
    when  (arguments -> 'ebs_optimized')::bool is true then ' EBS optimization enabled'
    else ' EBS optimization disabled'
  end || '.' as reason,
  path,
  start_line,
  end_line,
  source
from
  terraform_resource
where
  type = 'aws_instance';