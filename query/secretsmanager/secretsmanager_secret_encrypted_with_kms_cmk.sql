select
  type || ' ' || name as resource,
  case
    when coalesce(trim((arguments ->> 'kms_key_id')), '') = '' or
      (arguments ->> 'kms_key_id') = 'aws/secretsmanager'
    then 'alarm'
    else 'ok'
  end as status,
  name || case
    when coalesce(trim((arguments ->> 'kms_key_id')), '') = '' or
      (arguments ->> 'kms_key_id') = 'aws/secretsmanager'
    then ' is encrypted at rest default KMS key'
    else ' is encrypted at rest using customer-managed CMK'
  end || '.' as reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'aws_secretsmanager_secret';