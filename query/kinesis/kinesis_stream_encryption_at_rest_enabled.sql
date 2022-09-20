select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'encryption_type') = 'KMS' then 'ok'
    else 'alarm'
  end as status,
  name || case
    when (arguments ->> 'encryption_type') = 'KMS' then ' encrypted aty rest'
    else ' not encrypted at rest'
  end || '.' as reason,
  path,
  start_line,
  end_line,
  source
from
  terraform_resource
where
  type = 'aws_kinesis_stream';