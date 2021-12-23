-- Re-validate
-- select
--   -- Required Columns
--   arn as resource,
--   case
--     when vpc_id is null then 'alarm'
--     else 'ok'
--   end as status,
--   case
--     when vpc_id is null then title || ' not in VPC.'
--     else title || ' in VPC.'
--   end as reason,
--   -- Additional Dimensions
--   region,
--   account_id
-- from
--   aws_ec2_instance;

-- +---------------------------------------------------------------------------------------------------------------------------------------
-- | resource                | eni
-- +-------------------------+---------------------------------------------------------------------------------------------------------------------------------------
-- | aws_instance foo2       | {"device_index": 0, "network_interface_id": "${aws_network_interface.foo.id}"}
-- | aws_instance web        | <null>
-- | aws_instance web        | <null>
-- | aws_instance foo        | [{"device_index": 0, "network_interface_id": "${aws_network_interface.foo.id}"}, {"device_index": 1, "network_interface_id": "${aws_ne
-- | aws_instance tf_rajweb2 | {"device_index": 0, "network_interface_id": "${aws_network_interface.tf_foo.id}"}
-- +---------------------------------------------------------------------------------------------------------------------------------------

select
  -- Required Columns
  type || ' ' || name as resource,
  case
    when
      arguments ->> 'network_interface' is not null then 'ok' else 'alarm'
  end as status,
  case
    when
      arguments ->> 'network_interface' is not null then  name || ' associated with VPC.'
      else name || ' not associated with VPC.'
  end as reason,
  path
from
  terraform_resource
where
  type = 'aws_instance';