with cloudfront_distribution as (
  select
    *
  from
    terraform_resource
  where
    type = 'aws_cloudfront_distribution'
), origins as (
   select
      count(*),
      name
    from
      cloudfront_distribution,
      jsonb_array_elements(arguments -> 'origin') as o
    where
      (o ->> 'domain_name' ) like '%aws_s3_bucket%' and
      (o -> 's3_origin_config' ->> 'origin_access_identity') = ''
    group by name
)
select
  type || ' ' || a.name as resource,
  case
    when b.name is not null then 'alarm'
    else 'ok'
  end as status,
  case
    when b.name is not null then ' origin access identity not configured'
    else ' origin access identity configured'
  end || '.' reason,
  path
from
  cloudfront_distribution as a
  left join origins as b on a.name = b.name
