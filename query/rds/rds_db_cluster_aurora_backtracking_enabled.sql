select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'engine') not like any (array ['%aurora%', '%aurora-mysql%']) then 'skip'
    when (arguments -> 'backtrack_window') is not null then 'ok'
    else 'alarm'
  end as status,
  name || case
    when (arguments ->> 'engine') not like any (array ['%aurora%', '%aurora-mysql%']) then ' not Aurora MySQL-compatible edition'
    when (arguments -> 'backtrack_window') is not null then ' backtracking enabled'
    else ' backtracking not enabled'
  end || '.' as reason,
  path
from
  terraform_resource
where
  type = 'aws_rds_cluster';
  