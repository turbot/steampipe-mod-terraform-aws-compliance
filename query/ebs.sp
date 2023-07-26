query "ebs_volume_encryption_at_rest_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'encrypted') is null then 'alarm'
        when (arguments ->> 'encrypted')::bool then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments -> 'encrypted') is null then ' ''encrypted'' is not defined'
        when (arguments ->> 'encrypted')::bool then ' encrypted'
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
      type || ' ' || name as resource,
      case
        when (arguments -> 'encrypted') is null then 'alarm'
        when (arguments ->> 'encrypted')::bool then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments -> 'encrypted') is null then ' ''encrypted'' is not defined'
        when (arguments ->> 'encrypted')::bool then ' encrypted'
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