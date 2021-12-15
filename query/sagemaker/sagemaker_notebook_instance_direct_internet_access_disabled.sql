select
  type || ' ' || name as resource,
case
  when 
    coalesce(trim(arguments ->> 'direct_internet_access'), '') in ('', 'Enabled')
  then 'alarm'
  else 'ok'
end as status,
name || case
  when
    coalesce(trim(arguments ->> 'direct_internet_access'), '') = ''
  then 
    ' ''direct_internet_access'' is not defined.'
  when 
    trim(arguments ->> 'direct_internet_access') = 'Enabled'
  then ' direct internet access enabled.'
  else ' direct internet access disabled.'
end as reason,
path
from
  terraform_resource
where
  type = 'aws_sagemaker_notebook_instance';