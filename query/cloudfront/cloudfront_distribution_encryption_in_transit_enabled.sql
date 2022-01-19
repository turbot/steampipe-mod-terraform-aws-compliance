with cloudfront_distribution as (
  select
    *
  from
    terraform_resource
  where type = 'aws_cloudfront_distribution'
), data as (
  select
    distinct name
  from
    cloudfront_distribution,
      jsonb_array_elements(
    case jsonb_typeof(arguments -> 'ordered_cache_behavior' -> 'Items')
        when 'array' then (arguments -> 'ordered_cache_behavior' -> 'Items')
        else null end
    ) as cb
  where
    cb ->> 'ViewerProtocolPolicy' = 'allow-all'
)
select
  type || ' ' || b.name as resource,
  case
    when d.name is not null or (arguments -> 'default_cache_behavior' ->> 'ViewerProtocolPolicy' = 'allow-all') then 'alarm'
    else 'ok'
  end  status,
  case
    when d.name is not null or (arguments -> 'default_cache_behavior' ->> 'ViewerProtocolPolicy' = 'allow-all') then ' data not encrypted in transit'
    else ' data encrypted in transit'
  end || '.' reason,
  path
from
  cloudfront_distribution as b
  left join data as d on b.name = d.name;