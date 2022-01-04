select
  type || ' ' || name as resource,
  case
    -- // kms_key_arn - This attribute should only be specified if the key is different from the default DynamoDB CMK, alias/aws/dynamodb.
    when (arguments -> 'server_side_encryption') is null then 'ok'
    else 'info'
  end status,
  name || case
    when (arguments -> 'server_side_encryption') is null then ' server-side encryption set to DynamoDB owned KMS key'
    else ' server-side encryption set to AWS owned CMK'
  end || '.' as reason,
  path
from
  terraform_resource
where
  type = 'aws_dynamodb_table';