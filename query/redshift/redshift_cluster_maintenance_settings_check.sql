select
  type || ' ' || name as resource,
  case
    when (arguments -> 'allow_version_upgrade') is null and (arguments -> 'automated_snapshot_retention_period') is null then 'alarm'
    when (arguments -> 'allow_version_upgrade') is null and (arguments -> 'automated_snapshot_retention_period')::integer >= 7 then 'ok'
    when (arguments -> 'allow_version_upgrade')::bool and (arguments -> 'automated_snapshot_retention_period')::integer >= 7 then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'allow_version_upgrade') is null and (arguments -> 'automated_snapshot_retention_period') is null then ' does not have the required maintenance settings'
    when (arguments -> 'allow_version_upgrade') is null and (arguments -> 'automated_snapshot_retention_period')::integer >= 7 then ' has the required maintenance settings'
    when (arguments -> 'allow_version_upgrade')::bool and (arguments -> 'automated_snapshot_retention_period')::integer >= 7 then ' has the required maintenance settings'
    else ' does not have the required maintenance settings'
  end || '.' as reason,
  path,
  start_line,
  end_line,
  source
from
  terraform_resource
where
  type = 'aws_redshift_cluster';