select
  type || ' ' || name as resource,
  case
    when (arguments -> 'kms_key_id') is null then 'alarm'
    else 'ok'
  end status,
  name || case
    when (arguments -> 'kms_key_id') is null then ' encryption at rest disabled'
    else ' encryption at rest enabled'
  end || '.' reason,
  path,
  start_line,
  end_line,
  source
from
  terraform_resource
where
  type = 'aws_sagemaker_notebook_instance';