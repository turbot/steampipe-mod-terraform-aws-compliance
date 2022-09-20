select
  type || ' ' || name as resource,
  case
    when (arguments -> 'account_aggregation_source' ->> 'all_regions')::boolean then 'ok'
    else 'ok'
  end status,
  name || case
    when (arguments -> 'account_aggregation_source' ->> 'all_regions')::boolean then ' enabled in all regions'
    else ' not enabled in all regions'
  end || '.' as reason,
  path,
  start_line,
  end_line,
  source
from
  terraform_resource
where
  type = 'aws_config_configuration_aggregator';