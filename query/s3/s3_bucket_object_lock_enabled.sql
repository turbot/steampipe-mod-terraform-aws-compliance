select
  type || ' ' || name as resource,
  case
    when coalesce(trim(arguments -> 'object_lock_configuration' ->> 'object_lock_enabled'), '') = 'Enabled'
    then 'ok'
    else 'alarm'
  end status,
  name || case
    when arguments -> 'object_lock_configuration' -> 'object_lock_enabled' is null
    then ' ''object_lock_enabled'' is not defined.'
    when arguments -> 'object_lock_configuration' ->> 'object_lock_enabled' = 'Enabled'
    then ' object lock enabled.'
    else ' object lock not enabled.'
  end as reason,
  path
from
  terraform_resource
where
  type = 'aws_s3_bucket';