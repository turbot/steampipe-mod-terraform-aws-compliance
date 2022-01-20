select
  type || ' ' || name as resource,
  case
    when (arguments -> 'publicly_accessible') is null then 'ok'
    when (arguments -> 'publicly_accessible')::bool then 'alarm'
    else 'ok'
  end status,
  name || case
    when (arguments -> 'publicly_accessible') is null then ' not publicly accessible'
    when (arguments -> 'publicly_accessible')::bool then ' publicly accessible'
    else ' not publicly accessible'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'aws_dms_replication_instance';