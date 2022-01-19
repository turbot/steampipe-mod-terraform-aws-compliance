select
  -- Required Columns
  type || ' ' || name as resource,
  case
    when
      (arguments ->> 'block_public_acls')::boolean
      and (arguments ->> 'block_public_policy')::boolean
      and (arguments ->> 'ignore_public_acls')::boolean
      and (arguments ->> 'restrict_public_buckets')::boolean
    then 'ok'
    else 'alarm'
  end as status,
  case
    when 
      arguments -> 'block_public_acls' is null
      or arguments -> 'block_public_policy' is null
      or arguments -> 'ignore_public_acls' is null
      or arguments -> 'restrict_public_buckets' is null 
    then concat_ws(', ',
        case when arguments -> 'block_public_acls' is null then 'block_public_acls' end,
        case when arguments -> 'block_public_policy' is null then 'block_public_policy' end,
        case when arguments -> 'ignore_public_acls' is null then 'ignore_public_acls' end,
        case when arguments -> 'restrict_public_buckets' is null then 'restrict_public_buckets' end
      ) || ' not defined.'
    when 
      (arguments ->> 'block_public_acls')::boolean
      and (arguments ->> 'block_public_policy')::boolean
      and (arguments ->> 'ignore_public_acls')::boolean
      and (arguments ->> 'restrict_public_buckets')::boolean
    then 'Public access blocks enabled.'
    else 'Public access not enabled for: ' ||
      concat_ws(', ',
        case when not ((arguments ->> 'block_public_acls')::boolean) then 'block_public_acls' end,
        case when not ((arguments ->> 'block_public_policy')::boolean) then 'block_public_policy' end,
        case when not ((arguments ->> 'ignore_public_acls')::boolean ) then 'ignore_public_acls' end,
        case when not ((arguments ->> 'restrict_public_buckets')::boolean) then 'restrict_public_buckets' end
      ) || '.'
  end as reason,
  path
from
  terraform_resource
where
  type = 'aws_s3_bucket_public_access_block';