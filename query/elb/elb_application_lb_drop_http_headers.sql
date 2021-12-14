select
  type || ' ' || name as resource,
  case
    when (arguments -> 'drop_invalid_header_fields') is null then 'alarm'
    when (arguments -> 'drop_invalid_header_fields')::bool then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'drop_invalid_header_fields') is null then ' ''drop_invalid_header_fields'' disabled'
    when (arguments -> 'drop_invalid_header_fields')::bool then ' ''drop_invalid_header_fields'' enabled'
    else ' ''drop_invalid_header_fields'' disabled'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'aws_lb';