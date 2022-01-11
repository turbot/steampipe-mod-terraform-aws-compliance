select
  type || ' ' || name as resource,
  case
    when (arguments -> 'attributes') is null then 'alarm'
    when (arguments -> 'attributes' -> 'flow_logs_enabled') is null then 'alram'
    when (arguments -> 'attributes' -> 'flow_logs_enabled')::bool then 'ok'
    else 'alarm'
  end as status,
  name || case
    when (arguments -> 'attributes') is null then ' flow log not enabled'
    when (arguments -> 'attributes' -> 'flow_logs_enabled') is null then ' flow log not enabled'
    when (arguments -> 'attributes' -> 'flow_logs_enabled')::bool then ' flow log enabled'
    else ' flow log not enabled'
  end || '.' as reason,
  path
from
  terraform_resource
where
  type = 'aws_globalaccelerator_accelerator';