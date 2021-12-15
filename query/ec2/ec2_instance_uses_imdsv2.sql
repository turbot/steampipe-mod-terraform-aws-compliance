select
  type || ' ' || name as resource,
case
  when 
    coalesce(trim(arguments -> 'metadata_options' ->> 'http_tokens'), '') in ('optional', '')
  then 'alarm'
  else 'ok'
end as status,
name || case
  when
    coalesce(trim(arguments -> 'metadata_options' ->> 'http_tokens'), '') = ''
  then 
    ' ''http_tokens'' is not defined.'
  when 
    trim(arguments -> 'metadata_options' ->> 'http_tokens') <> 'required'
  then ' not configured to use Instance Metadata Service Version 2 (IMDSv2).'
  else ' configured to use Instance Metadata Service Version 2 (IMDSv2).'
end as reason,
path
from
  terraform_resource
where
  type = 'aws_instance';