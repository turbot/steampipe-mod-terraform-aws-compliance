select
  type || ' ' || name as resource,
  case
    when (arguments -> 'log_publishing_options') @> '[{"log_type": "ES_APPLICATION_LOGS"}]' and
    (arguments -> 'log_publishing_options') @> '[{"log_type": "ES_APPLICATION_LOGS"}]' and
    (arguments -> 'log_publishing_options') @> '[{"log_type": "ES_APPLICATION_LOGS"}]' then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'log_publishing_options') @> '[{"log_type": "ES_APPLICATION_LOGS"}]' and
    (arguments -> 'log_publishing_options') @> '[{"log_type": "ES_APPLICATION_LOGS"}]' and
    (arguments -> 'log_publishing_options') @> '[{"log_type": "ES_APPLICATION_LOGS"}]' then ' logging enabled for search , index and error'
    else ' logging not enabled for all search, index and error'
  end || '.' reason,
  path,
  start_line,
  end_line,
  source
from
  terraform_resource
where
  type = 'aws_elasticsearch_domain';
