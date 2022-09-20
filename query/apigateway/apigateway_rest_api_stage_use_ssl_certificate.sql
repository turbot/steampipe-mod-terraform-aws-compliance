select
  type || ' ' || name as resource,
  case
    when (arguments -> 'client_certificate_id') is null then 'alarm'
    else 'ok'
  end status,
  name || case
    when (arguments -> 'client_certificate_id') is null then ' does not use SSL certificate'
    else ' uses SSL certificate'
  end || '.' reason,
  path,
  start_line,
  end_line,
  source
from
  terraform_resource
where
  type = 'aws_api_gateway_stage';