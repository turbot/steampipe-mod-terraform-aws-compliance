select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'service_name') like '%sqs%' and (arguments -> 'private_dns_enabled') is null then 'alarm'
    when (arguments ->> 'service_name') like '%sqs%' and (arguments -> 'private_dns_enabled')::bool then 'ok'
    when (arguments ->> 'service_name') like '%sqs%' and (arguments -> 'private_dns_enabled')::bool = false then 'alarm'
    else 'alarm'
  end as status,
  name || case
    when (arguments ->> 'service_name') like '%sqs%' and (arguments -> 'private_dns_enabled') is null then ' private DNS disabled'
    when (arguments ->> 'service_name') like '%sqs%' and (arguments -> 'private_dns_enabled')::bool then ' private DNS enabled'
    when (arguments ->> 'service_name') like '%sqs%' and (arguments -> 'private_dns_enabled')::bool = false then ' private DNS disabled'
  end || '.' as reason,
  path,
  start_line,
  end_line,
  source
from
  terraform_resource
where
  type = 'aws_vpc_endpoint';