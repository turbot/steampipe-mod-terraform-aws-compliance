select
  type || ' ' || name as resource,
  case
    when jsonb_typeof(arguments -> 'network_interface') is null then 'skip'
    when (jsonb_typeof(arguments -> 'network_interface'))::text = 'object'  then 'ok'
    else 'alarm'
  end status,
  name || case
    when jsonb_typeof(arguments -> 'network_interface') is null then ' has no ENI attached'
    when (jsonb_typeof(arguments -> 'network_interface'))::text = 'object' then ' has 1 ENI attached'
    else ' has ' || (jsonb_array_length(arguments -> 'network_interface')) || ' ENI(s) attached'
  end || '.' as reason,
  path,
  start_line,
  end_line,
  source
from
  terraform_resource
where
  type = 'aws_instance';