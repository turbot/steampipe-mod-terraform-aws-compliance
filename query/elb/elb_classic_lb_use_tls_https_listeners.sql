select
  type || ' ' || name as resource,
  case
    when (arguments -> 'listener' ->> 'lb_protocol') like any (array ['HTTPS', 'TLS']) then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'listener' ->> 'lb_protocol') like any (array ['HTTPS', 'TLS']) then ' configured with ' || (arguments -> 'listener' ->> 'lb_protocol') || ' protocol'
    else ' not configured with HTTPS or TLS protocol'
    end || '.' reason,
    path
from
  terraform_resource
where
  type = 'aws_elb';