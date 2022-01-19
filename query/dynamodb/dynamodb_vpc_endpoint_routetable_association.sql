select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'service_name') like '%dynamodb%' and (arguments -> 'route_table_ids') is null then 'alarm'
    when (arguments ->> 'service_name') like '%dynamodb%' and (arguments -> 'route_table_ids') is not null then 'ok'
    else 'alarm'
  end as status,
  name || case
    when (arguments ->> 'service_name') like '%dynamodb%' and (arguments -> 'route_table_ids') is null then ' VPC Endpoint for DynamoDB is not enabled'
    when (arguments ->> 'service_name') like '%dynamodb%' and (arguments -> 'route_table_ids') is not null then ' VPC Endpoint for DynamoDB is enabled'
    else ' VPC Endpoint for DynamoDB is not enabled'
  end || '.' as reason,
  path
from
  terraform_resource
where
  type = 'aws_vpc_endpoint';