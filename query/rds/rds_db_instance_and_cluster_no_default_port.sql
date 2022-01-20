(
  select
    type || ' ' || name as resource,
    case
      when (arguments -> 'engine') is null and (arguments -> 'port') is null then 'alarm'
      when (arguments ->> 'engine') similar to '%(aurora|mysql|mariadb)%' and ((arguments ->> 'port')::int = 3306 or (arguments -> 'port') is null) then 'alarm'
      when (arguments ->> 'engine') like '%postgres%' and ((arguments ->> 'port')::int = 5432  or (arguments -> 'port') is null) then 'alarm'
      when (arguments ->> 'engine') like 'oracle%' and ((arguments ->> 'port')::int = 1521 or (arguments -> 'port') is null) then 'alarm'
      when (arguments ->> 'engine') like 'sqlserver%' and ((arguments ->> 'port')::int = 1433 or (arguments -> 'port') is null) then 'alarm'
      else 'ok'
    end status,
    name || case
      when (arguments -> 'engine') is null and (arguments -> 'port') is null then ' uses a default port'
      when (arguments ->> 'engine') similar to '%(aurora|mysql|mariadb)%' and ((arguments ->> 'port')::int = 3306 or (arguments -> 'port') is null) then ' uses a default port'
      when (arguments ->> 'engine') like '%postgres%' and ((arguments ->> 'port')::int = 5432  or (arguments -> 'port') is null) then ' uses a default port'
      when (arguments ->> 'engine') like 'oracle%' and ((arguments ->> 'port')::int = 1521 or (arguments -> 'port') is null) then ' uses a default port'
      when (arguments ->> 'engine') like 'sqlserver%' and ((arguments ->> 'port')::int = 1433 or (arguments -> 'port') is null) then ' uses a default port'
      else ' does not use a default port'
    end || '.' reason,
    path
  from
    terraform_resource
  where
    type = 'aws_rds_cluster'
)
union
(
  select
    type || ' ' || name as resource,
    case
      when (arguments ->> 'engine') similar to '%(aurora|mysql|mariadb)%' and ((arguments ->> 'port')::int = 3306 or (arguments -> 'port') is null) then 'alarm'
      when (arguments ->> 'engine') like '%postgres%' and ((arguments ->> 'port')::int = 5432  or (arguments -> 'port') is null) then 'alarm'
      when (arguments ->> 'engine') like 'oracle%' and ((arguments ->> 'port')::int = 1521 or (arguments -> 'port') is null) then 'alarm'
      when (arguments ->> 'engine') like 'sqlserver%' and ((arguments ->> 'port')::int = 1433 or (arguments -> 'port') is null) then 'alarm'
      else 'ok'
    end status,
    name || case
      when (arguments ->> 'engine') similar to '%(aurora|mysql|mariadb)%' and ((arguments ->> 'port')::int = 3306 or (arguments -> 'port') is null) then ' uses a default port'
      when (arguments ->> 'engine') like '%postgres%' and ((arguments ->> 'port')::int = 5432  or (arguments -> 'port') is null) then ' uses a default port'
      when (arguments ->> 'engine') like 'oracle%' and ((arguments ->> 'port')::int = 1521 or (arguments -> 'port') is null) then ' uses a default port'
      when (arguments ->> 'engine') like 'sqlserver%' and ((arguments ->> 'port')::int = 1433 or (arguments -> 'port') is null) then ' uses a default port'
      else ' does not use a default port'
    end || '.' reason,
    path
  from
    terraform_resource
  where
    type = 'aws_db_instance'
);
