select
  type || ' ' || name as resource,
  case
    when (arguments -> 'publicly_accessible') is null then 'alarm'
    when (arguments -> 'publicly_accessible')::bool then 'alarm'
    else 'ok'
  end status,
  name || case
    when (arguments -> 'publicly_accessible') is null then ' publicly accessible'
    when (arguments -> 'publicly_accessible')::bool then ' publicly accessible'
    else ' not publicly accessible'
  end || '.' as reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'aws_redshift_cluster';

