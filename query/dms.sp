query "dms_replication_instance_not_publicly_accessible" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'publicly_accessible') is null then 'ok'
        when (attributes_std -> 'publicly_accessible')::bool then 'alarm'
        else 'ok'
      end status,
      address || case
        when (attributes_std -> 'publicly_accessible') is null then ' not publicly accessible'
        when (attributes_std -> 'publicly_accessible')::bool then ' publicly accessible'
        else ' not publicly accessible'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_dms_replication_instance';
  EOQ
}

query "dms_replication_instance_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'kms_key_arn') is null then 'alarm'
        else 'ok'
      end as status,
      address || case
        when (attributes_std -> 'kms_key_arn') is null then ' not encrypted with KMS CMK'
        else ' encrypted with KMS CMK'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_dms_replication_instance';
  EOQ
}

query "dms_replication_instance_automatic_minor_version_upgrade_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'auto_minor_version_upgrade')::bool then 'ok'
        else 'alarm'
      end as status,
      address || case
        when (attributes_std -> 'auto_minor_version_upgrade')::bool then ' automatic minor version upgrade enabled'
        else ' automatic minor version upgrade disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_dms_replication_instance';
  EOQ
}

query "dms_s3_endpoint_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'kms_key_arn') is null then 'alarm'
        else 'ok'
      end as status,
      address || case
        when (attributes_std -> 'kms_key_arn') is null then ' not encrypted with KMS CMK'
        else ' encrypted with KMS CMK'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'aws_dms_s3_endpoint';
  EOQ
}