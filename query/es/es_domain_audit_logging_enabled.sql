select
  type || ' ' || name as resource,
  case
    when ((arguments -> 'log_publishing_options' ->> 'cloudwatch_log_group_arn') is not null
    and (arguments -> 'log_publishing_options' ->> 'log_type')::text = 'AUDIT_LOGS')
    or
    ((arguments -> 'log_publishing_options') @> '[{"log_type": "AUDIT_LOGS"}]') then 'ok'
    else 'alarm'
  end status,
  name || case
    when  ((arguments -> 'log_publishing_options' ->> 'cloudwatch_log_group_arn') is not null and (arguments -> 'log_publishing_options' ->> 'log_type')::text = 'AUDIT_LOGS')
    or
    ((arguments -> 'log_publishing_options') @> '[{"log_type": "AUDIT_LOGS"}]') then ' audit logging enabled'
    else ' audit logging disabled'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'aws_elasticsearch_domain';
