select
  type || ' ' || name as resource,
  case
    when (arguments -> 'deletion_protection') is null then 'alarm'
    when (arguments -> 'deletion_protection')::bool then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'deletion_protection') is null then ' ''deletion_protection'' disabled'
    when (arguments -> 'deletion_protection')::bool then ' ''deletion_protection'' enabled'
    else '  ''deletion_protection'' disabled'
  end || '.' as reason,
  path
from
  terraform_resource
where
  type = 'aws_rds_cluster';