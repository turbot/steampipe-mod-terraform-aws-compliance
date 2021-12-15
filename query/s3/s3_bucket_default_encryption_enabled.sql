select
  -- Required Columns
  type || ' ' || name as resource,
  case
    when 
      coalesce(trim(arguments -> 'server_side_encryption_configuration' -> 'rule' -> 'apply_server_side_encryption_by_default' ->> 'sse_algorithm'), '') not in ('aws:kms', 'AES256')
    then 'alarm'
    else 'ok'
  end as status,
  name || case
    when 
      coalesce(trim(arguments -> 'server_side_encryption_configuration' -> 'rule' -> 'apply_server_side_encryption_by_default' ->> 'sse_algorithm'), '') = ''
    then 
      ' ''sse_algorithm'' is not defined.'
    when 
      trim(arguments -> 'server_side_encryption_configuration' -> 'rule' -> 'apply_server_side_encryption_by_default' ->> 'sse_algorithm') in ('aws:kms', 'AES256')
    then 
      ' default encryption enabled.'
    else ' default encryption disabled.'
  end as reason,
  path
from
  terraform_resource
where
  type = 'aws_s3_bucket';