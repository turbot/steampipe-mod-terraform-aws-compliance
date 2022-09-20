select
  type || ' ' || name as resource,
  case
    when (arguments -> 'drop_invalid_header_fields') is null then 'alarm'
    when (arguments -> 'drop_invalid_header_fields')::boolean then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'drop_invalid_header_fields') is null then ' ''drop_invalid_header_fields'' disabled'
    when (arguments -> 'drop_invalid_header_fields')::boolean then ' ''drop_invalid_header_fields'' enabled'
    else ' ''drop_invalid_header_fields'' disabled'
  end || '.' reason,
  path,
  start_line,
  end_line,
  source
from
  terraform_resource
where
  type = 'aws_lb';