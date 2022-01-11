select
  type || ' ' || name as resource,
  case
    when name in (select split_part((arguments -> 'aws_efs_backup_policy' ->> 'file_system_id')::text, '.', 2) from terraform_resource where type = 'aws_internet_gateway' and (arguments -> 'backup_policy' ->> 'status')::text = 'ENABLED') then 'ok' else 'alarm'
  end as status,
  name || case
    when 
      arguments -> 'encrypted' is null then ' ''encrypted'' is not defined.'
    when 
      (arguments ->> 'encrypted')::boolean then '  encrypted at rest.'
    else ' not encrypted at rest.'
  end as reason,
  path
from
  terraform_resource
where
  type = 'aws_efs_file_system';