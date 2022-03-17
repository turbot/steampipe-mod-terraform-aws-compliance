(
  select
    type || ' ' || name as resource,
    case
      when (arguments -> 'access_logs') is null then 'alarm'
      when (arguments -> 'access_logs' -> 'enabled')::bool then 'ok'
      else 'alarm'
    end status,
    name || case
      when (arguments -> 'access_logs') is null then ' logging disabled'
      when (arguments -> 'access_logs' -> 'enabled')::bool then ' logging enabled'
      else ' logging disabled'
    end || '.' as reason,
    path || ':' || start_line
  from
    terraform_resource
  where
    type = 'aws_lb'
)
union
(
  select
    type || ' ' || name as resource,
    case
      when (arguments -> 'access_logs') is null then 'alarm'
      when (arguments -> 'access_logs' -> 'enabled')::bool then 'ok'
      else 'alarm'
    end status,
    name || case
      when (arguments -> 'access_logs') is null then ' logging disabled'
      when (arguments -> 'access_logs' -> 'enabled')::bool then ' logging enabled'
      else ' logging disabled'
      end || '.' reason,
      path || ':' || start_line
  from
    terraform_resource
  where
    type = 'aws_elb'
);