select
  type || ' ' || name as resource,
  case
    when (arguments -> 'domain_endpoint_options' ->> 'tls_security_policy') = 'Policy-Min-TLS-1-2-2019-07' then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'domain_endpoint_options'  ->> 'tls_security_policy') = 'Policy-Min-TLS-1-2-2019-07' then ' encrypted using TLS 1.2'
    else ' not encrypted using TLS 1.2'
  end || '.' reason,
  path,
  start_line,
  end_line,
  source
from
  terraform_resource
where
  type = 'aws_elasticsearch_domain';
