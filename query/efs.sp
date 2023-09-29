query "efs_file_system_automatic_backups_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when name in (select split_part((attributes_std ->> 'file_system_id')::text, '.', 2) from terraform_resource where type = 'aws_efs_backup_policy' and (attributes_std -> 'backup_policy' ->> 'status')::text = 'ENABLED') then 'ok' else 'alarm'
      end as status,
      address || case
        when name in (select split_part((attributes_std ->> 'file_system_id')::text, '.', 2) from terraform_resource where type = 'aws_efs_backup_policy' and (attributes_std -> 'backup_policy' ->> 'status')::text = 'ENABLED') then ' backup policy enabled'
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
      address as resource,
      case
        when (attributes_std -> 'encrypted') is null then 'alarm'
        when (attributes_std ->> 'encrypted')::boolean then 'ok'
        else 'alarm'
      end as status,
      address || case
        when (attributes_std -> 'encrypted') is null then ' ''encrypted'' is not defined'
        when (attributes_std ->> 'encrypted')::boolean then ' encrypted at rest'
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
      address as resource,
      case
        when (attributes_std -> 'posix_user') is null then 'alarm'
        when (attributes_std -> 'posix_user' -> 'gid') is not null then 'ok'
        else 'alarm'
      end as status,
      address || case
        when (attributes_std -> 'posix_user') is null then ' ''posix_user'' is not defined'
        when (attributes_std -> 'posix_user' -> 'gid') is not null then ' has user identity'
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
      address as resource,
      case
        when (attributes_std -> 'root_directory') is null then 'alarm'
        when (attributes_std -> 'root_directory' -> 'path') is not null then 'ok'
        else 'alarm'
      end as status,
      address || case
        when (attributes_std -> 'root_directory') is null then ' ''root_directory'' is not defined'
        when (attributes_std -> 'root_directory' -> 'path') is not null then ' has root directory'
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

query "efs_file_system_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'kms_key_id') is null then 'alarm'
        else 'ok'
      end as status,
      address || case
        when (attributes_std -> 'kms_key_id') is null then ' not encrypted with KMS CMK'
        else ' encrypted with KMS CMK'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_efs_file_system';
  EOQ
}
