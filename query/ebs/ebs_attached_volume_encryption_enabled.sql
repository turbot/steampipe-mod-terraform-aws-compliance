select
  type || ' ' || name as resource,
  case
    when (arguments -> 'encrypted') is null then 'alarm'
    when (arguments ->> 'encrypted')::bool then 'ok'
    else 'alarm'
  end as status,
  name || case
    when (arguments -> 'encrypted') is null then ' ''encrypted'' is not defined.'
    when (arguments ->> 'encrypted')::bool then ' encrypted.'
    else ' not encrypted.'
  end || '.' as reason,
  path,
  start_line,
  end_line,
  source
from
  terraform_resource
where
  type = 'aws_ebs_volume';