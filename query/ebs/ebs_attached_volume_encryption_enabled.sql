select
  -- Required Columns
  type || ' ' || name as resource,
  case
    when
      (arguments ->> 'encrypted')::boolean then 'ok' else 'alarm'
  end as status,
  name || case
    when 
      arguments -> 'encrypted' is null then ' ''encrypted'' is not defined.'
    when 
      (arguments ->> 'encrypted')::boolean then ' encrypted.'
    else ' not encrypted.'
  end as reason,
  path
from
  terraform_resource
where
  type = 'aws_ebs_volume';