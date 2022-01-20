select
  type || ' ' || name as resource,
  case
    when (arguments -> 'encrypted') is null then 'alarm'
    when (arguments ->> 'encrypted')::boolean then 'ok'
    else 'alarm'
  end as status,
  name || case
    when (arguments -> 'encrypted') is null then ' ''encrypted'' is not defined'
    when (arguments ->> 'encrypted')::boolean then ' encrypted at rest'
    else ' not encrypted at rest'
  end || '.' as reason,
  path
from
  terraform_resource
where
  type = 'aws_efs_file_system';