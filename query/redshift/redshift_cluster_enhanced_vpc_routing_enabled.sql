select
  type || ' ' || name as resource,
  case
    when (arguments -> 'enhanced_vpc_routing') is null then 'alarm'
    when (arguments -> 'enhanced_vpc_routing')::bool then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'enhanced_vpc_routing') is null then ' ''enhanced_vpc_routing'' set to false by default'
    when (arguments -> 'enhanced_vpc_routing')::bool then '  ''enhanced_vpc_routing'' set to true'
    else ' ''allow_version_upgrade'' set to false'
  end || '.' as reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'aws_redshift_cluster';