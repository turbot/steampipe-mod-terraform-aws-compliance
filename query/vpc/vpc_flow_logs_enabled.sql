with flow_logs as (
  select
    arguments ->> 'vpc_id' as flow_log_vpc_id
  from
    terraform_resource
  where
    type = 'aws_flow_log'
), all_vpc as (
    select
      '${aws_vpc.' || name || '.id}' as vpc_id,
      *
    from
      terraform_resource
    where
      type = 'aws_vpc'
)
select
  a.type || ' ' || a.name as resource,
  case
    when b.flow_log_vpc_id is not null then 'ok'
    else 'alarm'
  end as status,
  a.name || case
    when b.flow_log_vpc_id is not null then ' flow logging enabled'
    else ' flow logging disabled'
  end || '.' reason,
  a.path || ':' || a.start_line
from
  all_vpc as a
  left join flow_logs as b on a.vpc_id = b.flow_log_vpc_id;
