query "timestream_database_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'kms_key_id') is not null then 'ok'
        else 'alarm'
      end as status,
      address || case
        when (attributes_std ->> 'kms_key_id') is not null then ' encrypted with KMS'
        else ' not encrypted with KMS'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_timestreamwrite_database';
  EOQ
}
