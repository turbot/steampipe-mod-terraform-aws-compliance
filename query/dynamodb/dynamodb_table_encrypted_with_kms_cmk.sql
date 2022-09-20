select
  type || ' ' || name as resource,
  case
    -- // kms_key_arn - This attribute should only be specified if the key is different from the default DynamoDB CMK, alias/aws/dynamodb.
    -- This query only checks if table is encrypted by default AWS KMS i.e. If enabled is false then server-side encryption is set to AWS owned CMK
    when (arguments -> 'server_side_encryption' ->> 'enabled')::bool is false then 'alarm'
    when (arguments -> 'server_side_encryption'->> 'enabled')::bool is true and (arguments -> 'server_side_encryption' ->> 'kms_key_arn') is not null then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'server_side_encryption' ->> 'enabled')::bool is false then ' encrypted by DynamoDB managed and owned AWS KMS key'
    when (arguments -> 'server_side_encryption'->> 'enabled')::bool is true and (arguments -> 'server_side_encryption' ->> 'kms_key_arn') is not null then ' encrypted by AWS managed CMK'
    else ' not encrypted by AWS managed CMK'
  end || '.' as reason,
  path,
  start_line,
  end_line,
  source
from
  terraform_resource
where
  type = 'aws_dynamodb_table';
