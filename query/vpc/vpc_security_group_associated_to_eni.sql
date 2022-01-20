select
  type || ' ' || name as resource,
  case
    when name in (select split_part((jsonb_array_elements(arguments -> 'security_groups')::text), '.', 2) from terraform_resource where type = 'aws_network_interface') then 'ok'
    else 'alarm'
  end status,
  name || case
   when name in (select split_part((jsonb_array_elements(arguments -> 'security_groups')::text), '.', 2) from terraform_resource where type = 'aws_network_interface') then ' has attached ENI(s)'
   else ' has no attached ENI(s)'
  end || '.' as reason,
  path
from
  terraform_resource
where
  type = 'aws_security_group';