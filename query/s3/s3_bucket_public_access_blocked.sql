select
  -- Required Columns
  type || ' ' || name as resource,
  case
    when
      (arguments -> 'block_public_acls')::bool
      and (arguments -> 'block_public_policy')::bool
      and (arguments -> 'ignore_public_acls')::bool
      and (arguments -> 'restrict_public_buckets')::bool
    then
      'ok'
    else
      'alarm'
  end status
--   case
--     when
--       arguments -> 'block_public_acls'
--       and arguments -> 'block_public_policy'
--       and arguments -> 'ignore_public_acls'
--       and arguments -> 'restrict_public_buckets'
--     then name || ' blocks public access.'
--     else name || ' does not block public access.'
--   end reason,
  -- Additional Dimensions
--   region,
--   account_id
from
  terraform_resource
where  
  type = 'aws_s3_bucket';