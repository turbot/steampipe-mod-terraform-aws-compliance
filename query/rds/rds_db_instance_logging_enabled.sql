-- Incomplete
select
  type || ' ' || name as resource,
  (arguments -> 'engine')::text as engine,
  case
    when (arguments ->> 'engine')::text like any (array ['mariadb', '%mysql']) and (arguments -> 'enabled_cloudwatch_logs_exports') is not null and (arguments -> 'enabled_cloudwatch_logs_exports')::array @>  array ['audit','error','general','slowquery'] then 'ok'
    when (arguments ->> 'engine')::text like any (array['%postgres%']) and (arguments -> 'enabled_cloudwatch_logs_exports') is not null and (arguments -> 'enabled_cloudwatch_logs_exports')::array @> array ['postgresql','upgrade'] then 'ok'
    when (arguments ->> 'engine')::text like 'oracle%' and (arguments -> 'enabled_cloudwatch_logs_exports') is not null and (arguments -> 'enabled_cloudwatch_logs_exports')::array @> array ['alert','audit', 'trace','listener'] then 'ok'
    when (arguments ->> 'engine')::text = 'sqlserver-ex' and (arguments -> 'enabled_cloudwatch_logs_exports')is not null and (arguments -> 'enabled_cloudwatch_logs_exports')::array @> array ['error'] then 'ok'
    when (arguments ->> 'engine')::text like 'sqlserver%' and (arguments -> 'enabled_cloudwatch_logs_exports')is not null and (arguments -> 'enabled_cloudwatch_logs_exports')::array @> array ['error','agent'] then 'ok'
    else 'alarm'
  end as status,
--   case
--     when engine like any (array ['mariadb', '%mysql']) and enabled_cloudwatch_logs_exports ?& array ['audit','error','general','slowquery']
--     then title || ' ' || engine || ' logging enabled.'
--     when engine like any (array['%postgres%']) and enabled_cloudwatch_logs_exports ?& array ['postgresql','upgrade']
--     then title || ' ' || engine || ' logging enabled.'
--     when engine like 'oracle%' and enabled_cloudwatch_logs_exports ?& array ['alert','audit', 'trace','listener']
--     then title || ' ' || engine || ' logging enabled.'
--     when engine = 'sqlserver-ex' and enabled_cloudwatch_logs_exports ?& array ['error']
--     then title || ' ' || engine || ' logging enabled.'
--     when engine like 'sqlserver%' and enabled_cloudwatch_logs_exports ?& array ['error','agent']
--     then title || ' ' || engine || ' logging enabled.'
--     else title || ' logging not enabled.'
--   end as reason,
  path
from
  terraform_resource
where
  type = 'aws_db_instance';
