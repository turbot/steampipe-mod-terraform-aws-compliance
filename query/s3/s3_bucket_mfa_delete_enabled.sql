select
  type || ' ' || name as resource,
  case
    when (arguments -> 'versioning' -> 'enabled')::bool and (arguments -> 'versioning' -> 'mfa_delete')::bool then 'ok'
    -- Alarm if properties are set to false or aren't defined
    else 'alarm'
  end as status,
  name || case
    when arguments -> 'versioning' is null then ' ''versioning'' is not defined'
    when arguments -> 'versioning' -> 'enabled' is null then ' ''versioning.enabled'' is not defined'
    when not (arguments -> 'versioning' -> 'enabled')::bool then ' versioning is disabled'
    when arguments -> 'versioning' -> 'mfa_delete' is null then ' ''versioning.mfa_delete'' is not defined'
    when (arguments -> 'versioning' -> 'mfa_delete')::bool then ' MFA delete enabled' else 'MFA delete disabled'
  end || '.' as reason,
  path
from
  terraform_resource
where
  type = 'aws_s3_bucket';
