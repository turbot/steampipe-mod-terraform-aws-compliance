select
  type || ' ' || name as resource,
  case
    when (arguments -> 'publicly_accessible') is null then 'ok'
    when (arguments -> 'publicly_accessible')::boolean then 'alarm'
    else 'ok'
  end status,
  name || case
    when (arguments -> 'publicly_accessible') is null then ' not publicly accessible'
    when (arguments -> 'publicly_accessible')::boolean then ' publicly accessible'
    else ' not publicly accessible'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'aws_db_instance';