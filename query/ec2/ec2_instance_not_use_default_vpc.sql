select
  type || ' ' || name as resource,
  case
    when (arguments -> 'subnet_id') is null then 'skip'
    when split_part((arguments ->> 'subnet_id'), '.', 2) in (select name from terraform_resource where type = 'aws_subnet' and (arguments ->> 'vpc_id') like '%default%') then 'alarm'
    else 'ok'
  end as status,
  name || case
    when (arguments -> 'subnet_id') is null then ' does not have a subnet id defined'
    when split_part((arguments ->> 'subnet_id'), '.', 2) in (select name from terraform_resource where type = 'aws_subnet' and (arguments ->> 'vpc_id') like '%default%') then ' deployed to a default VPC'
    else ' not deployed to a default VPC'
  end || '.' as reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'aws_instance';