-- | name       | type         | arguments
-- | rajweb2    | aws_instance | {"ami":"${data.aws_ami.ubuntu.id}","instance_type":"t2.micro","root_block_device":{"delete_on_termination":true,"volume_size":10,"volume_type":"gp2"},"tags":{"N
-- | tf_rajweb2 | aws_instance | {"ami":"${data.aws_ami.ubuntu.id}","instance_type":"t2.micro","tags":{"Name":"RajHelloWorld"}}
select
  type || ' ' || name as resource,
  case
    when  (arguments -> 'root_block_device' ->> 'delete_on_termination')::bool is true then 'ok'
    else 'alarm'
  end as status,
  name || case
    when (arguments -> 'root_block_device' ->> 'delete_on_termination')::bool is true then ' instance termination protection enabled.'
    else ' instance termination protection disabled.'
  end reason,
  path
from
  terraform_resource
where
  type = 'aws_instance';