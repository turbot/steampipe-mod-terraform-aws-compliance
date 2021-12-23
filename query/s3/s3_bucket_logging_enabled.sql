select
  -- Required Columns
  type || ' ' || name as resource,
  case
    when 
      coalesce(trim(arguments -> 'logging' ->> 'target_bucket'), '') = ''
    then 'alarm'
    else 'ok'
  end as status,
  name || case
    when 
      arguments -> 'logging' -> 'target_bucket' is null
    then 
      ' ''target_bucket'' is not defined.'
    when 
      coalesce(trim(arguments -> 'logging' ->> 'target_bucket'), '') = ''
    then 
      ' logging disabled.'
    else ' logging enabled.'
  end as reason,
  path
from
  terraform_resource
where
  type = 'aws_s3_bucket';