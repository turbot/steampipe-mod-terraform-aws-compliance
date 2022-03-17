select
  type || ' ' || name as resource,
  case
    when (arguments -> 'copy_tags_to_snapshot') is null then 'alarm'
    when (arguments -> 'copy_tags_to_snapshot')::bool then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'copy_tags_to_snapshot') is null then ' ''copy_tags_to_snapshot'' disabled'
    when (arguments -> 'copy_tags_to_snapshot')::bool then ' ''copy_tags_to_snapshot'' enabled'
    else ' ''copy_tags_to_snapshot'' disabled'
  end || '.' as reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'aws_rds_cluster';