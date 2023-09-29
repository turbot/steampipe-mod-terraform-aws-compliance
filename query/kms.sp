query "kms_cmk_rotation_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'enable_key_rotation') is null then 'alarm'
        when (attributes_std -> 'enable_key_rotation')::boolean then 'ok'
        else 'alarm'
      end as status,
      address || case
        when (attributes_std -> 'enable_key_rotation') is null then ' key rotation disabled'
        when (attributes_std -> 'enable_key_rotation')::boolean then ' key rotation enabled'
        else ' key rotation disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_kms_key';
  EOQ
}
