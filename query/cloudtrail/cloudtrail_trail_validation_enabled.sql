select
  -- Required Columns
  type || ' ' || name as resource,
  case
    when (arguments -> 'enable_log_file_validation') ::bool then 'ok'
    else 'alarm'
  end as status
-- TODO: Add reason
--   case
--     when enable_log_file_validation then title || ' log file validation enabled.'
--     else title || ' log file validation disabled.'
--   end as reason,
--   -- Additional Dimensions
--   region,
--   account_id
from
  terraform_resource
where 
  type = 'aws_cloudtrail';