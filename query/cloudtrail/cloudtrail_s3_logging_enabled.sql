select
  -- Required Columns
  type || ' ' || name as resource,
  case
    when (arguments -> 'enable_logging') ::bool then 'ok'
    else 'alarm'
  end as status
-- Add the reason section
from
  terraform_resource
where 
  type = 'aws_cloudtrail';