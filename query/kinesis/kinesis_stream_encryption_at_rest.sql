select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'encryption_type') = 'KMS'
    then 'ok'
    else 'alarm'
  end as status,
  name || case
    when (arguments ->> 'encryption_type') = 'KMS'
    then ' is encrypted'
    else ' is not encrypted'
  end || '.' as reason,
  path
from
  terraform_resource
where
  type = 'aws_kinesis_stream';