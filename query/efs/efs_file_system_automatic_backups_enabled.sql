select
  type || ' ' || name as resource,
  case
    when name in (select split_part((arguments ->> 'file_system_id')::text, '.', 2) from terraform_resource where type = 'aws_efs_backup_policy' and (arguments -> 'backup_policy' ->> 'status')::text = 'ENABLED') then 'ok' else 'alarm'
  end as status,
  name || case
    when name in (select split_part((arguments ->> 'file_system_id')::text, '.', 2) from terraform_resource where type = 'aws_efs_backup_policy' and (arguments -> 'backup_policy' ->> 'status')::text = 'ENABLED') then ' backup policy enabled'
    else ' backup policy disabled'
  end || '.' as reason,
  path,
  start_line,
  end_line,
  source
from
  terraform_resource
where
  type = 'aws_efs_file_system';