select
  type || ' ' || name as resource,
  case
    when name in (select split_part((arguments ->> 'vpc_id')::text, '.', 2) from terraform_resource where type = 'aws_internet_gateway') then 'ok'
    else 'alarm'
  end status,
  name || case
   when name in (select split_part((arguments ->> 'vpc_id')::text, '.', 2) from terraform_resource where type = 'aws_internet_gateway') then ' has internet gateway attachment(s)'
   else ' has no internet gateway attachment(s)'
  end || '.' as reason,   
  path
from
  terraform_resource
where
  type = 'aws_vpc';