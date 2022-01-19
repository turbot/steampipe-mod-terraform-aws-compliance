select
  -- Required Columns
  type || ' ' || name as resource,
  case
    when (arguments -> 'egress') is null and (arguments -> 'ingress') is null then 'ok'
    else 'alarm'
  end as status,
  case
    when (arguments -> 'ingress') is not null and (arguments -> 'egress') is not null then 'Default security group ' || name || ' has inbound and outbound rules.'
    when
      (arguments -> 'ingress') is not null and (arguments -> 'egress') is null
    then
      'Default security group ' || name || ' has inbound rules.'
    when
      (arguments -> 'ingress') is null and (arguments -> 'egress') is not null
    then
      'Default security group ' || name || ' has outbound rules.'
    else 'Default security group ' || name || ' has no inbound or outbound rules.'
  end as reason,
  path
from
  terraform_resource
where
  type = 'aws_default_security_group';