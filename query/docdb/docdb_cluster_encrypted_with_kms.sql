select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'storage_encrypted')::boolean and
      coalesce(trim(arguments ->> 'kms_key_id'), '') <> ''
    then 'ok'
    else 'alarm'
  end as status,
  name || case
    when (arguments ->> 'storage_encrypted')::boolean and
      coalesce(trim(arguments ->> 'kms_key_id'), '') <> ''
    then ' is encrypted at rest using customer-managed CMK'
    else ' is not encrypted at rest using customer-managed CMK'
  end || '.' as reason,
  path
from
  terraform_resource
where
  type = 'aws_docdb_cluster';