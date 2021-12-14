--TODO -Add different test cases
select
  type || ' ' || name as resource,
  case
    when (arguments -> 'logging') is null then 'alarm'
    when (arguments -> 'logging' ->> 'enabled')::bool then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'logging') is null then ' audit logging disabled'
    when (arguments -> 'logging' ->> 'enabled')::bool then ' audit logging enabled'
    else ' audit logging disabled'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'aws_redshift_cluster';
