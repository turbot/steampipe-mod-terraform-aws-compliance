query "efs_file_system_automatic_backups_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when name in (select split_part((arguments ->> 'file_system_id')::text, '.', 2) from terraform_resource where type = 'aws_efs_backup_policy' and (arguments -> 'backup_policy' ->> 'status')::text = 'ENABLED') then 'ok' else 'alarm'
      end as status,
      name || case
        when name in (select split_part((arguments ->> 'file_system_id')::text, '.', 2) from terraform_resource where type = 'aws_efs_backup_policy' and (arguments -> 'backup_policy' ->> 'status')::text = 'ENABLED') then ' backup policy enabled'
        else ' backup policy disabled'
      end || '.' as reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_efs_file_system';
  EOQ
}

query "efs_file_system_encrypt_data_at_rest" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'encrypted') is null then 'alarm'
        when (arguments ->> 'encrypted')::boolean then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments -> 'encrypted') is null then ' ''encrypted'' is not defined'
        when (arguments ->> 'encrypted')::boolean then ' encrypted at rest'
        else ' not encrypted at rest'
      end || '.' as reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_efs_file_system';
  EOQ
}
