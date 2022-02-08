select
  type || ' ' || name as resource,
  case
    when coalesce(trim(arguments ->> 'encryption_key'), '') = ''
    then 'alarm'
    else 'ok'
  end as status,
  name || case
    when coalesce(trim(arguments ->> 'encryption_key'), '') = '' then ' is not encrypted'
    else ' is encrypted'
  end || '.' as reason,
  path
from
  terraform_resource
where
  type = 'aws_codebuild_project';