select
  -- Required Columns
  type || ' ' || name as resource,
  case
    when (arguments -> 'image_scanning_configuration' ->> 'scan_on_push')::boolean then 'ok'
    else 'alarm'
  end as status,
  name || case
    when (arguments -> 'image_scanning_configuration' ->> 'scan_on_push')::boolean then ' use image scanning'
    else ' does not use image scannings'
  end as reason,
  path
from
  terraform_resource
where
  type = 'aws_ecr_repository';