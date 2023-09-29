query "fsx_ontap_file_system_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'kms_key_id') is null then 'alarm'
        else 'ok'
      end status,
      address || case
        when (attributes_std -> 'kms_key_id') is null then ' is not encrypted with KMS CMK'
        else ' is encrypted with KMS CMK'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_fsx_ontap_file_system';
  EOQ 
}

query "fsx_openzfs_file_system_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'kms_key_id') is null then 'alarm'
        else 'ok'
      end status,
      address || case
        when (attributes_std -> 'kms_key_id') is null then ' is not encrypted with KMS CMK'
        else ' is encrypted with KMS CMK'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_fsx_openzfs_file_system';
  EOQ 
}

query "fsx_windows_file_system_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'kms_key_id') is null then 'alarm'
        else 'ok'
      end status,
      address || case
        when (attributes_std -> 'kms_key_id') is null then ' is not encrypted with KMS CMK'
        else ' is encrypted with KMS CMK'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_fsx_windows_file_system';
  EOQ 
}

query "fsx_lustre_file_system_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'kms_key_id') is null then 'alarm'
        else 'ok'
      end status,
      address || case
        when (attributes_std -> 'kms_key_id') is null then ' is not encrypted with KMS CMK'
        else ' is encrypted with KMS CMK'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_fsx_lustre_file_system';
  EOQ 
}