query "keyspaces_table_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'encryption_specification' -> 'kms_key_identifier') is not null and (attributes_std -> 'encryption_specification' ->> 'type') = 'CUSTOMER_MANAGED_KMS_KEY' then 'ok'
        else 'alarm'
      end status,
      address || case
        when (attributes_std -> 'encryption_specification' -> 'kms_key_id') is not null and (attributes_std -> 'encryption_specification' ->> 'type') = 'CUSTOMER_MANAGED_KMS_KEY' then ' uses KMS CMK'
        else ' does not use KMS CMK'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_keyspaces_table';
  EOQ
}