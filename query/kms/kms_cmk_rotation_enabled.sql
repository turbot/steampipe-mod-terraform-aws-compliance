select
  -- Required Columns
  -- Check if you can use arn as resource
  type || ' ' || name as resource,
  case
    when (arguments -> 'enable_key_rotation')::bool then 'ok'
    else 'alarm'
  end as status
-- Add the reason section
from
  terraform_resource
where 
  type = 'aws_kms_key';