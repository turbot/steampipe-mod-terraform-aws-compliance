select
  type || ' ' || name as resource,
  case
    when (arguments -> 'rule') is null then 'alarm'
    when (arguments -> 'rule' -> 'lifecycle') is null then 'ok'
    when (arguments -> 'rule' -> 'lifecycle' ->> 'delete_after')::int >=35 then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'rule') is null then ' retention period not set'
    when (arguments -> 'rule' -> 'lifecycle') is null then ' retention period set to never expire'
    else ' retention period set to ' || (arguments -> 'rule' -> 'lifecycle' ->> 'delete_after')::int
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'aws_backup_plan';