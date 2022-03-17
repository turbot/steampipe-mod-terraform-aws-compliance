select
  type || ' ' || name as resource,
  case
    when (arguments -> 'enable_deletion_protection') is null then 'alarm'
    when (arguments -> 'enable_deletion_protection')::boolean then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'enable_deletion_protection') is null then ' ''enable_deletion_protection'' not defined'
    when (arguments -> 'enable_deletion_protection')::boolean then ' deletion protection enabled'
    else ' deletion protection disabled'
  end || '.' as reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'aws_lb';