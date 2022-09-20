select
  type || ' ' || name as resource,
  case
    when (arguments -> 'cluster_config' -> 'dedicated_master_enabled')::bool = false then 'alarm'
    when (arguments -> 'cluster_config' -> 'dedicated_master_enabled')::bool and (arguments -> 'cluster_config' ->> 'instance_count')::int >= 3 then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'cluster_config' -> 'dedicated_master_enabled')::bool = false then ' dedicated master nodes disabled'
    else ' has ' || (arguments -> 'cluster_config' ->> 'instance_count') || ' data node(s)'
  end || '.' reason,
  path,
  start_line,
  end_line,
  source
from
  terraform_resource
where
  type = 'aws_elasticsearch_domain';