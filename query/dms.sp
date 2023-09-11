query "dms_replication_instance_not_publicly_accessible" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'publicly_accessible') is null then 'ok'
        when (arguments -> 'publicly_accessible')::bool then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'publicly_accessible') is null then ' not publicly accessible'
        when (arguments -> 'publicly_accessible')::bool then ' publicly accessible'
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
      type || ' ' || name as resource,
      case
        when (arguments -> 'kms_key_arn') is null then 'alarm'
        else 'ok'
      end as status,
      name || case
        when (arguments -> 'kms_key_arn') is null then ' not encrypted with KMS CMK'
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
      type || ' ' || name as resource,
      case
        when (arguments -> 'auto_minor_version_upgrade')::bool then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments -> 'auto_minor_version_upgrade')::bool then ' automatic minor version upgrade enabled'
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
      type || ' ' || name as resource,
      case
        when (arguments -> 'kms_key_arn') is null then 'alarm'
        else 'ok'
      end as status,
      name || case
        when (arguments -> 'kms_key_arn') is null then ' not encrypted with KMS CMK'
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