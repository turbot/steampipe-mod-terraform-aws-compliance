select
  type || ' ' || name as resource,
  case
    when (arguments -> 'image_scanning_configuration' ->> 'scan_on_push')::boolean then 'ok'
    else 'alarm'
  end as status,
  name || case
    when (arguments -> 'image_scanning_configuration' ->> 'scan_on_push')::boolean then ' uses image scanning'
    else ' does not use image scanning'
  end || '.' as reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'aws_ecr_repository';