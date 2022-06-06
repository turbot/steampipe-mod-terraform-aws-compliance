select
  type || ' ' || name as resource,
  case
    when (arguments -> 'subnet_ids') is null then 'alarm'
    else 'ok'
  end status,
  name || case
    when (arguments -> 'subnet_ids') is null then ' not associated with subnets'
    else ' associated with ' || (jsonb_array_length(arguments -> 'subnet_ids')) || ' subnet(s)'
  end || '.' as reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'aws_network_acl';