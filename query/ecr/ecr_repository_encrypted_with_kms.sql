select
  type || ' ' || name as resource,
  case
    when
      (arguments ->> 'encryption_configuration') is not null
      and coalesce((arguments -> 'encryption_configuration' ->> 'encryption_type'), '') = 'KMS'
    then 'ok'
    else 'alarm'
  end as status,
  name || case
    when
      (arguments ->> 'encryption_configuration') is not null
      and coalesce((arguments -> 'encryption_configuration' ->> 'encryption_type'), '') = 'KMS'
    then ' encrypted using KMS'
    else ' not encrypted using KMS'
  end || '.' as reason,
  path,
  start_line,
  end_line,
  source
from
  terraform_resource
where
  type = 'aws_ecr_repository';