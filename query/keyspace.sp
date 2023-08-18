query "keyspaces_table_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'encryption_specification' -> 'kms_key_identifier') is not null and (arguments -> 'encryption_specification' ->> 'type') = 'CUSTOMER_MANAGED_KMS_KEY' then 'ok'
        else 'alarm'
      end status,
      name || case
        when (arguments -> 'encryption_specification' -> 'kms_key_id') is not null and (arguments -> 'encryption_specification' ->> 'type') = 'CUSTOMER_MANAGED_KMS_KEY' then ' uses KMS CMK'
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