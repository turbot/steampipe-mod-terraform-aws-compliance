select
  -- Required Columns
  type || ' ' || name as resource,
  case
    when (arguments -> 'storage_encrypted')::bool then 'ok'
    -- Alarm if property is set to false or isn't defined
    else 'alarm'
  end as status,
  name || case
    when arguments -> 'storage_encrypted' is null then ' ''storage_encrypted'' is not defined'
    when (arguments -> 'storage_encrypted')::bool then ' encrypted at rest' else ' not encrypted at rest'
  end || '.' as reason,
  -- Additional Dimensions
  path
from
  terraform_resource
where
  type = 'aws_db_instance';
