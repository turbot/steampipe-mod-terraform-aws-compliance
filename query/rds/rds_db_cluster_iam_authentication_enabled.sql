select
  type || ' ' || name as resource,
  case
    when (arguments -> 'iam_database_authentication_enabled') is null then 'alarm'
    when (arguments -> 'iam_database_authentication_enabled')::bool then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'iam_database_authentication_enabled') is null then ' ''iam_database_authentication_enabled'' disabled'
    when (arguments -> 'iam_database_authentication_enabled')::bool then ' ''iam_database_authentication_enabled'' enabled'
    else '  ''iam_database_authentication_enabled'' disabled'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'aws_rds_cluster';