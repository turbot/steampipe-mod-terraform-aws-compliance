select
  -- Required Columns
  type || ' ' || name as resource,
  case
    when (arguments -> 'enabled') is null then 'alarm'
    when (arguments ->> 'enabled')::bool then 'ok' 
    else 'alarm'
  end as status,
  name || case
    when (arguments -> 'enabled') is null then ' ''enabled'' is not defined'
    when (arguments ->> 'enabled')::bool then ' default EBS encryption enabled'
    else ' default EBS encryption disabled'
  end || '.' as reason,
  path
from
  terraform_resource
where
  type = 'aws_ebs_encryption_by_default';