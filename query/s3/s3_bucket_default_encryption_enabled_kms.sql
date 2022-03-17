select
  type || ' ' || name as resource,
  case
    when coalesce(trim(arguments -> 'server_side_encryption_configuration' -> 'rule' -> 'apply_server_side_encryption_by_default' ->> 'sse_algorithm'), '') <> 'aws:kms'
    then 'alarm'
    else 'ok'
  end as status,
  name || case
    when coalesce(trim(arguments -> 'server_side_encryption_configuration' -> 'rule' -> 'apply_server_side_encryption_by_default' ->> 'sse_algorithm'), '') = '' then ' ''sse_algorithm'' is not defined'
    when trim(arguments -> 'server_side_encryption_configuration' -> 'rule' -> 'apply_server_side_encryption_by_default' ->> 'sse_algorithm') = 'aws:kms' then ' default encryption with KMS enabled'
    else ' default encryption with KMS disabled'
  end || '.' as reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'aws_s3_bucket';