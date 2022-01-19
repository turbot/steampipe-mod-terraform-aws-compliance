select
  type || ' ' || name as resource,
  case
    when (arguments -> 'enable_deletion_protection') is null then 'alarm'
    when (arguments -> 'enable_deletion_protection')::boolean then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'enable_deletion_protection') is null then ' ''enable_deletion_protection'' disabled'
    when (arguments -> 'enable_deletion_protection')::boolean then ' ''enable_deletion_protection'' enabled'
    else ' ''enable_deletion_protection'' disabled'
  end || '.' as reason,
  path
from
  terraform_resource
where
  type = 'aws_lb';