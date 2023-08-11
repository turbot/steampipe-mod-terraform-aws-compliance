query "fsx_ontap_file_system_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'kms_key_id') is null then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'kms_key_id') is null then ' is not encrypted with KMS CMK'
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