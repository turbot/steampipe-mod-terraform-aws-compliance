select
  type || ' ' || name as resource,
  case
    when (arguments -> 'encrypted') is null then 'alarm'
    when (arguments -> 'logging') is null then 'alarm'
    when (arguments -> 'logging' ->> 'enabled')::bool then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'encrypted') is null then ' not encrypted'
    when (arguments -> 'logging') is null then ' audit logging disabled'
    when (arguments -> 'logging' ->> 'enabled')::bool then ' audit logging enabled'
    else ' audit logging disabled'
  end || '.' as reason,
  path
from
  terraform_resource
where
  type = 'aws_redshift_cluster';
