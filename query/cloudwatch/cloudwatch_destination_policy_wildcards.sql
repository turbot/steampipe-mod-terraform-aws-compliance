with access_policy as (
  select
    name
  from
    terraform_data_source
  where
    type = 'aws_iam_policy_document'
    and (arguments -> 'statement' ->> 'actions') like '%*%'
), cloudwatch_log_destination_policy as (
    select
      name,
      type,
      path,
      start_line,
      split_part((arguments ->> 'access_policy')::text, '.', 3) as ap
    from
      terraform_resource
    where
      type = 'aws_cloudwatch_log_destination_policy'
)
select
  type || ' ' || a.name as resource,
  case
    when e.name is null then 'ok'
    else 'alarm'
  end as status,
  a.name || case
    when e.name is null then ' policy is ok'
    else ' policy is not ok'
  end || '.' as reason,
  path || ':' || start_line
from
  cloudwatch_log_destination_policy as a
  left join access_policy as e on a.ap = e.name;
