select
  type || ' ' || name as resource,
  case
    when (arguments -> 'allow_version_upgrade') is null then 'ok'
    when (arguments -> 'allow_version_upgrade')::bool then 'ok'
    else 'ok'
  end status,
  name || case
    when (arguments -> 'allow_version_upgrade') is null then ' ''allow_version_upgrade'' set to true by default'
    when (arguments -> 'allow_version_upgrade')::bool then '  ''allow_version_upgrade'' set to true'
    else ' ''allow_version_upgrade'' set to false'
  end || '.' as reason,
  path
from
  terraform_resource
where
  type = 'aws_redshift_cluster';