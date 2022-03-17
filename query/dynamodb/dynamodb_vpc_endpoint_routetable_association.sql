select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'service_name') like '%dynamodb%' and (arguments -> 'route_table_ids') is null then 'alarm'
    when (arguments ->> 'service_name') like '%dynamodb%' and (arguments -> 'route_table_ids') is not null then 'ok'
    else 'alarm'
  end as status,
  name || case
    when (arguments ->> 'service_name') like '%dynamodb%' and (arguments -> 'route_table_ids') is null then ' VPC Endpoint for DynamoDB disabled'
    when (arguments ->> 'service_name') like '%dynamodb%' and (arguments -> 'route_table_ids') is not null then ' VPC Endpoint for DynamoDB enabled'
    else ' VPC Endpoint for DynamoDB disabled'
  end || '.' as reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'aws_vpc_endpoint';