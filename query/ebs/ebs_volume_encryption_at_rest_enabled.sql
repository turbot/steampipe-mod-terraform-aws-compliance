select
  -- Required Columns
  type || ' ' || name as resource,
  case
    when (arguments -> 'encrypted')::bool then 'ok'
    -- Alarm if property is set to false or isn't defined
    else 'alarm'
  end as status,
  name || case
    when arguments -> 'encrypted' is null then ' ''encrypted'' is not defined'
    when (arguments -> 'encrypted')::bool then ' encrypted at rest' else ' not encrypted at rest'
  end || '.' as reason,
  -- Additional Dimensions
  path
from
  terraform_resource
where
  type = 'aws_ebs_volume';
