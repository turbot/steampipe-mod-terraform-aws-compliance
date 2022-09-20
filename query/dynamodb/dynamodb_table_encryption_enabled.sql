select
  type || ' ' || name as resource,
  case
    when (arguments -> 'server_side_encryption') is not null then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'server_side_encryption') is not null then ' server-side encryption not set to DynamoDB owned KMS key'
    else ' server-side encryption set to AWS owned CMK'
  end || '.' as reason,
  path,
  start_line,
  end_line,
  source
from
  terraform_resource
where
  type = 'aws_dynamodb_table';