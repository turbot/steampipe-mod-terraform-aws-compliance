select
  type || ' ' || name as resource,
  case
    when (arguments -> 'monitoring')::bool then 'ok'
    -- Alarm if property is set to false or isn't defined
    else 'alarm'
  end as status,
  name || case
    when arguments -> 'monitoring' is null then ' ''monitoring'' is not defined'
    when (arguments -> 'monitoring')::bool then ' detailed monitoring is enabled' else 'detailed monitoring is disabled'
  end || '.' as reason,
  path
from
  terraform_resource
where
  type = 'aws_instance';
