select
  type || ' ' || name as resource,
  case
    when (arguments -> 'direct_internet_access') is null or (arguments ->> 'direct_internet_access') = 'Disabled' then 'ok'
    else 'alarm'
  end as status,
  name || case
    when trim(arguments ->> 'direct_internet_access') = '' then ' ''direct_internet_access'' is not defined'
    when (arguments -> 'direct_internet_access') is null or (arguments ->> 'direct_internet_access') = 'Disabled' then ' direct internet access disabled'
    else ' direct internet access enabled'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'aws_sagemaker_notebook_instance';