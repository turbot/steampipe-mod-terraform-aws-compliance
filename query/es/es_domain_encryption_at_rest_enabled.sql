select
  type || ' ' || name as resource,
  case
    when (arguments -> 'encrypt_at_rest' ->> 'enabled')::boolean then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'encrypt_at_rest' ->> 'enabled')::boolean then ' encryption at rest enabled'
    else ' encryption at rest disabled'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'aws_elasticsearch_domain';
