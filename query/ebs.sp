query "ebs_volume_encryption_at_rest_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'encrypted') is null then 'alarm'
        when (attributes_std ->> 'encrypted')::bool then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'encrypted') is null then ' ''encrypted'' is not defined'
        when (attributes_std ->> 'encrypted')::bool then ' encrypted'
        else ' not encrypted'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_ebs_volume';
  EOQ
}

query "ebs_snapshot_copy_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'encrypted') is null then 'alarm'
        when (attributes_std ->> 'encrypted')::bool then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'encrypted') is null then ' ''encrypted'' is not defined'
        when (attributes_std ->> 'encrypted')::bool then ' encrypted'
        else ' not encrypted'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_ebs_snapshot_copy';
  EOQ
}