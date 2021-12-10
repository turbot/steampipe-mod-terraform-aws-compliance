select
  type || ' ' || name as resource,
  case
    when not (arguments -> 'associate_public_ip_address')::bool then 'ok'
    -- Alarm if property is set to true or isn't defined
    else 'alarm'
  end as status,
  name || case
    when arguments -> 'associate_public_ip_address' is null then ' ''associate_public_address'' is not defined'
    when not (arguments -> 'associate_public_ip_address')::bool then ' not publicly accessible' else ' publicly accessible'
  end || '.' as reason,
  path
from
  terraform_resource
where
  type = 'aws_instance';
