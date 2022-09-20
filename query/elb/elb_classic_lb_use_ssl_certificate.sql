select
  type || ' ' || name as resource,
  case
    when (arguments -> 'listener') is null then 'skip'
    when (arguments -> 'listener' ->> 'lb_protocol') ilike 'SSL' and (arguments -> 'listener' -> 'ssl_certificate_id') is null then 'alarm'
    when (arguments -> 'listener' ->> 'lb_protocol') ilike 'SSL' and (arguments -> 'listener' ->> 'ssl_certificate_id') like 'arn:aws:acm%' then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'listener') is null then ' has no listener'
    when (arguments -> 'listener' ->> 'lb_protocol') ilike 'SSL' and (arguments -> 'listener' -> 'ssl_certificate_id') is null then ' does not use certificate provided by ACM'
    when (arguments -> 'listener' ->> 'lb_protocol') ilike 'SSL' and (arguments -> 'listener' ->> 'ssl_certificate_id') like 'arn:aws:acm%' then ' uses certificates provided by ACM'
    else ' does not use certificate provided by ACM'
  end || '.' reason,
  path,
  start_line,
  end_line,
  source
from
  terraform_resource
where
  type = 'aws_elb';