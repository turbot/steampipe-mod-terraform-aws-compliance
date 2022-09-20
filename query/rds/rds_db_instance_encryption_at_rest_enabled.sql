select
  type || ' ' || name as resource,
  case
    when (arguments -> 'storage_encrypted') is null then 'alarm'
    when (arguments -> 'storage_encrypted')::bool then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'storage_encrypted') is null then ' not encrypted'
    when (arguments -> 'storage_encrypted')::bool then ' encrypted'
    else ' not encrypted'
  end || '.' reason,
  path,
  start_line,
  end_line,
  source
from
  terraform_resource
where
  type = 'aws_db_instance';