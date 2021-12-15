select
  -- Required Columns
  type || ' ' || name as resource,
  case
    when coalesce(trim(arguments ->> 'kms_master_key_id'), '') = '' then 'alarm'
    else 'ok'
  end as status,
  name || case
    when coalesce(trim(arguments ->> 'kms_master_key_id'), '') = '' then ' ''kms_master_key_id'' is not defined.'
    when trim(arguments ->> 'kms_master_key_id') <> '' then ' encryption at rest enabled.'
  end as reason,
  path
from
  terraform_resource
where
  type = 'aws_sqs_queue';