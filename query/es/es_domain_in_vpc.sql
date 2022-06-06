select
  type || ' ' || name as resource,
  case
    when (arguments -> 'vpc_options' -> 'subnet_ids') is not null then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'vpc_options' -> 'subnet_ids') is not null then ' in VPC'
    else ' not in VPC'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'aws_elasticsearch_domain';
