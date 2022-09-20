select
  type || ' ' || name as resource,
  case
    when (arguments -> 'cors_rule')::jsonb ?& array['allowed_methods', 'allowed_origins'] then 'ok'
    else 'alarm'
  end as status,
  name || case
    when (arguments -> 'cors_rule') is null then ' ''cors_rule'' is not defined'
    when (arguments -> 'cors_rule')::jsonb ?& array['allowed_methods', 'allowed_origins'] then ' enabled with cross-region replication'
    else ' not enabled with cross-region replication'
  end || '.' reason,
  path,
  start_line,
  end_line,
  source
from
  terraform_resource
where
  type = 'aws_s3_bucket';