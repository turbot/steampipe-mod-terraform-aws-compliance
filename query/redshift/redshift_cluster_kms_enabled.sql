select
  type || ' ' || name as resource,
  case
    when (arguments -> 'encrypted') is not null and (arguments -> 'kms_key_id') is not null then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'encrypted') is not null and (arguments -> 'kms_key_id') is not null then ' encrypted with KMS'
    else ' not encrypted with KMS'
  end || '.' as reason,
  path,
  start_line,
  end_line,
  source
from
  terraform_resource
where
  type = 'aws_redshift_cluster';
