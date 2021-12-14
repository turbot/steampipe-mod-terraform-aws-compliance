(
select
  type || ' ' || name as resource,
  case
    when (arguments -> 'enabled_cloudwatch_logs_exports') is not null then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'enabled_cloudwatch_logs_exports') is not null then ' ''enabled_cloudwatch_logs_exports'' enabled'
    else '  ''enabled_cloudwatch_logs_exports'' disabled'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'aws_db_instance'
)
union 
(
select
  type || ' ' || name as resource,
  case
    when (arguments -> 'enabled_cloudwatch_logs_exports') is not null then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'enabled_cloudwatch_logs_exports') is not null then ' ''enabled_cloudwatch_logs_exports'' enabled'
    else '  ''enabled_cloudwatch_logs_exports'' disabled'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'aws_rds_cluster'
);
