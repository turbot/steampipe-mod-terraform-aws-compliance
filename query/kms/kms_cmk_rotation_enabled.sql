select
  type || ' ' || name as resource,
  case
    when (arguments -> 'enable_key_rotation') is null then 'alarm'
    when (arguments -> 'enable_key_rotation')::boolean then 'ok'
    else 'alarm'
  end as status,
  name || case
    when (arguments -> 'enable_key_rotation') is null then ' key rotation disabled'
    when (arguments -> 'enable_key_rotation')::boolean then ' key rotation enabled'
    else ' key rotation disabled'
  end || '.' as reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'aws_kms_key';