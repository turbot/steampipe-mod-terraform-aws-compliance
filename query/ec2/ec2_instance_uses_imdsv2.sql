select
  type || ' ' || name as resource,
  case
    when coalesce(trim(arguments -> 'metadata_options' ->> 'http_tokens'),'') in ('optional', '') then 'alarm'
    else 'ok'
  end as status,
  name || case
    when (arguments -> 'metadata_options' -> 'http_tokens') is null then ' ''http_tokens'' is not defined'
    when (arguments -> 'metadata_options' ->> 'http_tokens') = 'optional'
    then ' not configured to use Instance Metadata Service Version 2 (IMDSv2)'
    else ' configured to use Instance Metadata Service Version 2 (IMDSv2)'
  end || '.' as reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'aws_instance';