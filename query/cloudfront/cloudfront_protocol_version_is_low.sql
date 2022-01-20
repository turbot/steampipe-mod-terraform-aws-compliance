select
  type || ' ' || name as resource,
  case
    when (arguments -> 'viewer_certificate' ->> 'minimum_protocol_version')::text = 'TLSv1.2_2019' then 'ok'
    else 'ok'
  end status,
  name || case
    when (arguments -> 'viewer_certificate' ->> 'minimum_protocol_version')::text = 'TLSv1.2_2019' then ' minimum protocol version is set to TLSv1.2_2019'
    else ' minimum protocol version is not set to TLSv1.2_2019'
  end || '.' as reason,
  path
from
  terraform_resource
where
  type = 'aws_cloudfront_distribution';