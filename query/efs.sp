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
      ${local.tag_dimensions_sql}
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
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_efs_file_system';
  EOQ
}

query "efs_access_point_has_user_identity" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'posix_user') is null then 'alarm'
        when (arguments -> 'posix_user' -> 'gid') is not null then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments -> 'posix_user') is null then ' ''posix_user'' is not defined'
        when (arguments -> 'posix_user' -> 'gid') is not null then ' has user identity'
        else ' does not have user identity'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_efs_access_point';
  EOQ
}

query "efs_access_point_has_root_directory" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'root_directory') is null then 'alarm'
        when (arguments -> 'root_directory' -> 'path') is not null then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments -> 'root_directory') is null then ' ''root_directory'' is not defined'
        when (arguments -> 'root_directory' -> 'path') is not null then ' has root directory'
        else ' does not have root directory'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_efs_access_point';
  EOQ
}