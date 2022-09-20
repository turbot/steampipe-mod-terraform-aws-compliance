select
  type || ' ' || name as resource,
  case
    when coalesce(trim(arguments ->> 'kms_master_key_id'), '') = '' then 'alarm'
    else 'ok'
  end as status,
  name || case
    when (arguments -> 'kms_master_key_id') is null then ' ''kms_master_key_id'' is not defined'
    when coalesce(trim(arguments ->> 'kms_master_key_id'), '') <> '' then ' encryption at rest enabled'
    else ' encryption at rest disabled'
  end || '.' reason,
  path,
  start_line,
  end_line,
  source
from
  terraform_resource
where
  type = 'aws_sns_topic';