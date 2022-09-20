select
  type || ' ' || name as resource,
  case
    when (arguments -> 'node_to_node_encryption' ->> 'enabled')::boolean then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'node_to_node_encryption' ->> 'enabled')::boolean then ' node-to-node encryption enabled'
    else ' node-to-node encryption disabled'
  end || '.' reason,
  path,
  start_line,
  end_line,
  source
from
  terraform_resource
where
  type = 'aws_elasticsearch_domain';
