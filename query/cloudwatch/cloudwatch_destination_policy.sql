select
  type || ' ' || name as resource,
  case
    when name in (select split_part((arguments ->> 'destination_name')::text, '.', 2) from terraform_resource where type = 'aws_cloudwatch_log_destination_policy') then 'ok'
    else 'alarm'
  end status,
  name || case
    when name in (select split_part((arguments ->> 'destination_name')::text, '.', 2) from terraform_resource where type = 'aws_cloudwatch_log_destination_policy') then ' has cloudwatch log destination policy defined'
   else ' has no cloudwatch log destination policy defined'
  end || '.' as reason,   
  path
from
  terraform_resource
where
  type = 'aws_cloudwatch_log_destination';