select
  type || ' ' || name as resource,
  case
    when ((arguments -> 'log_publishing_options' ->> 'cloudwatch_log_group_arn') is not null
    and (arguments -> 'log_publishing_options' ->> 'log_type')::text = 'ES_APPLICATION_LOGS') or
    (arguments -> 'log_publishing_options') @> '[{"log_type": "ES_APPLICATION_LOGS"}]' then 'ok'
    else 'alarm'
  end status,
  name || case
    when ((arguments -> 'log_publishing_options' ->> 'cloudwatch_log_group_arn') is not null
    and (arguments -> 'log_publishing_options' ->> 'log_type')::text = 'ES_APPLICATION_LOGS') or (arguments -> 'log_publishing_options') @> '[{"log_type": "ES_APPLICATION_LOGS"}]' then ' error logging enabled'
    else ' error logging disabled'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'aws_elasticsearch_domain';
