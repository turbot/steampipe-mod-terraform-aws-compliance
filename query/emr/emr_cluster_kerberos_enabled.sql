select
  type || ' ' || name as resource,
  case
    when (arguments -> 'kerberos_attributes') is null then 'alarm'
    else 'ok'
  end as status,
  name || case
    when (arguments -> 'kerberos_attributes') is null then ' kerberos disabled'
    else ' kerberos enabled'
  end || '.' as reason,
  path
from
  terraform_resource
where
  type = 'aws_emr_cluster';