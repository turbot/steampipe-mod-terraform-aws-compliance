select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'image_tag_mutability')::text = 'IMMUTABLE' then 'ok'
    else 'alarm'
  end as status,
  name || case
    when (arguments ->> 'image_tag_mutability')::text = 'IMMUTABLE' then ' has immutable tags'
    else ' does not have immutable tags'
  end || '.' as reason,
  path
from
  terraform_resource
where
  type = 'aws_ecr_repository';