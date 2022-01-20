select
  type || ' ' || name as resource,
  case
    when coalesce(trim(lower(arguments -> 'versioning' ->> 'mfa_delete')), '') in ('true', 'false') and (arguments -> 'versioning' ->> 'mfa_delete')::bool then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'versioning' ->> 'mfa_delete')::bool then ' MFA delete enabled'
    else ' MFA delete disabled'
  end || '.' as reason,
  path
from
  terraform_resource
where
  type = 'aws_s3_bucket';