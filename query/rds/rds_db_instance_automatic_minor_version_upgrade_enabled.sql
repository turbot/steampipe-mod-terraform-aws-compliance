select
  type || ' ' || name as resource,
  case
    when (arguments -> 'auto_minor_version_upgrade') is null then 'ok'
    when (arguments -> 'auto_minor_version_upgrade')::boolean then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'auto_minor_version_upgrade') is null then ' ''auto_minor_version_upgrade'' enabled'
    when (arguments -> 'deletion_protection')::boolean then ' ''auto_minor_version_upgrade'' enabled'
    else ' ''auto_minor_version_upgrade'' disabled'
  end || '.' as reason,
  path
from
  terraform_resource
where
  type = 'aws_db_instance';