select
  type || ' ' || name as resource,
  (arguments -> 'engine')::text as engine,
  case
    when
      (arguments ->> 'engine')::text like any (array ['mariadb', '%mysql'])
      and (arguments -> 'enabled_cloudwatch_logs_exports') is not null
      and (arguments -> 'enabled_cloudwatch_logs_exports')::jsonb <@ '["audit","error","general","slowquery"]'::jsonb
      and (arguments -> 'enabled_cloudwatch_logs_exports')::jsonb @> '["audit","error","general","slowquery"]'::jsonb then 'ok'
    when
      (arguments ->> 'engine')::text like any (array['%postgres%'])
      and (arguments -> 'enabled_cloudwatch_logs_exports') is not null
      and (arguments -> 'enabled_cloudwatch_logs_exports')::jsonb <@ '["postgresql","upgrade"]'::jsonb
      and (arguments -> 'enabled_cloudwatch_logs_exports')::jsonb @> '["postgresql","upgrade"]'::jsonb then 'ok'
    when
      (arguments ->> 'engine')::text like 'oracle%' and (arguments -> 'enabled_cloudwatch_logs_exports') is not null
      and (arguments -> 'enabled_cloudwatch_logs_exports')::jsonb <@ '["alert","audit", "trace","listener"]'::jsonb
      and (arguments -> 'enabled_cloudwatch_logs_exports')::jsonb @> '["alert","audit", "trace","listener"]'::jsonb then 'ok'
    when
      (arguments ->> 'engine')::text = 'sqlserver-ex'
      and (arguments -> 'enabled_cloudwatch_logs_exports') is not null
      and (arguments -> 'enabled_cloudwatch_logs_exports')::jsonb <@ '["error"]'::jsonb
      and (arguments -> 'enabled_cloudwatch_logs_exports')::jsonb @> '["error"]'::jsonb then 'ok'
    when
      (arguments ->> 'engine')::text like 'sqlserver%'
      and (arguments -> 'enabled_cloudwatch_logs_exports')is not null
      and (arguments -> 'enabled_cloudwatch_logs_exports')::jsonb <@ '["error","agent"]' then 'ok'
    else 'alarm'
  end as status,
  name || case
    when
      (arguments ->> 'engine')::text like any (array ['mariadb', '%mysql'])
      and (arguments -> 'enabled_cloudwatch_logs_exports') is not null
      and (arguments -> 'enabled_cloudwatch_logs_exports')::jsonb <@ '["audit","error","general","slowquery"]'::jsonb
      and (arguments -> 'enabled_cloudwatch_logs_exports')::jsonb @> '["audit","error","general","slowquery"]'::jsonb then ' logging enabled'
    when
      (arguments ->> 'engine')::text like any (array['%postgres%'])
      and (arguments -> 'enabled_cloudwatch_logs_exports') is not null
      and (arguments -> 'enabled_cloudwatch_logs_exports')::jsonb <@ '["postgresql","upgrade"]'::jsonb
      and (arguments -> 'enabled_cloudwatch_logs_exports')::jsonb @> '["postgresql","upgrade"]'::jsonb then ' logging enabled'
    when
      (arguments ->> 'engine')::text like 'oracle%'
      and (arguments -> 'enabled_cloudwatch_logs_exports') is not null
      and (arguments -> 'enabled_cloudwatch_logs_exports')::jsonb <@ '["alert","audit", "trace","listener"]'::jsonb
      and (arguments -> 'enabled_cloudwatch_logs_exports')::jsonb @> '["alert","audit", "trace","listener"]'::jsonb then ' logging enabled'
    when
      (arguments ->> 'engine')::text = 'sqlserver-ex'
      and (arguments -> 'enabled_cloudwatch_logs_exports') is not null
      and (arguments -> 'enabled_cloudwatch_logs_exports')::jsonb <@ '["error"]'::jsonb
      and (arguments -> 'enabled_cloudwatch_logs_exports')::jsonb @> '["error"]'::jsonb then ' logging enabled'
    when
      (arguments ->> 'engine')::text like 'sqlserver%'
      and (arguments -> 'enabled_cloudwatch_logs_exports')is not null
      and (arguments -> 'enabled_cloudwatch_logs_exports')::jsonb <@ '["error","agent"]' then ' logging enabled'
    else ' logging disabled'
  end || '.' as reason,
  path,
  start_line,
  end_line,
  source
from
  terraform_resource
where
  type = 'aws_db_instance';