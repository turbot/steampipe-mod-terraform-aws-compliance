select
  type || ' ' || name as resource,
  case
    when (arguments -> 'automated_snapshot_retention_period') is null then 'ok'
    when (arguments -> 'automated_snapshot_retention_period')::integer > 7 then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'automated_snapshot_retention_period') is null then ' ''automated_snapshot_retention_period'' set to 1 day by default'
    when (arguments -> 'automated_snapshot_retention_period')::integer > 7 then ' ''automated_snapshot_retention_period'' set to ' || (arguments ->> 'automated_snapshot_retention_period')::integer || ' day(s)'
    else ' ''automated_snapshot_retention_period'' set to 0 days'
  end || '.' as reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'aws_redshift_cluster';