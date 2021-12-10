select
  type || ' ' || name as resource,
  case
    when arguments -> 'server_side_encryption_configuration' is not null then 'ok'
    -- Alarm if property isn't defined
    else 'alarm'
  end as status,
  name || case
    when arguments -> 'server_side_encryption_configuration' is null then ' ''server_side_encryption_configuration'' is not defined'
    else ' default encryption enabled'
  end || '.' as reason,
  path
from
  terraform_resource
where
  type = 'aws_s3_bucket';
