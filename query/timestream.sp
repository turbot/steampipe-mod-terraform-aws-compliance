query "timestream_database_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'kms_key_id') is not null then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments ->> 'kms_key_id') is not null then ' encrypted with KMS'
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
