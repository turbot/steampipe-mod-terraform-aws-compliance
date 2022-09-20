select
  type || ' ' || name as resource,
  case
    when (arguments -> 'vpc') is null then 'skip'
    when (arguments -> 'instance') is not null or (arguments -> 'network_interface') is not null then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'vpc') is null then ' not associated with VPC'
    when (arguments -> 'instance') is not null or (arguments -> 'network_interface') is not null then ' associated with an instance or network interface'
    else ' not associated with an instance or network interface'
  end || '.' as reason,
  path,
  start_line,
  end_line,
  source
from
  terraform_resource
where
  type = 'aws_eip';