select
  type || ' ' || name as resource,
  case
    when  (arguments -> 'root_block_device' ->> 'delete_on_termination')::bool is true then 'ok'
    else 'alarm'
  end as status,
  name || case
    when (arguments -> 'root_block_device' ->> 'delete_on_termination')::bool is true then ' instance termination protection enabled.'
    else ' instance termination protection disabled.'
  end reason,
  path
from
  terraform_resource
where
  type = 'aws_instance';